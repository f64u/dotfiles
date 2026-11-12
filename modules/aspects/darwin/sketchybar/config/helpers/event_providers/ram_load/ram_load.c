#include <mach/mach.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include "../sketchybar.h"

// Fires <event> with
//   used_percent    100 - kern.memorystatus_level (memory_pressure -Q's "free")
//   pressure_level  1 normal, 2 warning, 4 critical
//   swap_rate       bytes/s swapped in + out since the last tick
//   swap_used       bytes currently in swap
static int read_int(const char* name) {
  int value = 0;
  size_t len = sizeof(value);
  if (sysctlbyname(name, &value, &len, NULL, 0) != 0) return -1;
  return value;
}

static uint64_t swap_pages(void) {
  vm_statistics64_data_t vm;
  mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
  if (host_statistics64(mach_host_self(), HOST_VM_INFO64,
                        (host_info64_t)&vm, &count) != KERN_SUCCESS) {
    return 0;
  }
  return vm.swapins + vm.swapouts;
}

static uint64_t swap_used(void) {
  struct xsw_usage usage;
  size_t len = sizeof(usage);
  if (sysctlbyname("vm.swapusage", &usage, &len, NULL, 0) != 0) return 0;
  return usage.xsu_used;
}

int main(int argc, char** argv) {
  float update_freq;
  if (argc < 3 || (sscanf(argv[2], "%f", &update_freq) != 1)) {
    printf("Usage: %s \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    exit(1);
  }

  alarm(0);
  char message[512];
  snprintf(message, 512, "--add event '%s'", argv[1]);
  sketchybar(message);

  uint64_t prev_pages = swap_pages();
  for (;;) {
    usleep(update_freq * 1000000);

    uint64_t pages = swap_pages();
    uint64_t rate = (pages - prev_pages) * vm_page_size / update_freq;
    prev_pages = pages;

    int free = read_int("kern.memorystatus_level");
    int level = read_int("kern.memorystatus_vm_pressure_level");
    if (free < 0 || level < 0) continue;

    snprintf(message, 512,
             "--trigger '%s' used_percent='%d' pressure_level='%d'"
             " swap_rate='%llu' swap_used='%llu'",
             argv[1], 100 - free, level, rate, swap_used());
    sketchybar(message);
  }
  return 0;
}
