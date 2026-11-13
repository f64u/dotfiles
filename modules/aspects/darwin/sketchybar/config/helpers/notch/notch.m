// Prints "<display> <origin x> <screen width> <notch left> <notch right>
// <notch height>" in points for each screen with a notch. <display> is the
// screen's 1-based NSScreen index, which is what sketchybar's `display`
// takes. Notch edges are local to the screen, taken from the side areas'
// widths so their coordinate space doesn't matter.
#import <AppKit/AppKit.h>

int main(void) {
  @autoreleasepool {
    NSArray<NSScreen*>* screens = [NSScreen screens];
    for (NSUInteger i = 0; i < screens.count; i++) {
      NSScreen* s = screens[i];
      CGFloat height = s.safeAreaInsets.top;
      if (height <= 0) continue;
      NSRect frame = s.frame;
      CGFloat left = s.auxiliaryTopLeftArea.size.width;
      CGFloat right = frame.size.width - s.auxiliaryTopRightArea.size.width;
      printf("%lu %g %g %g %g %g\n", (unsigned long)(i + 1), NSMinX(frame), frame.size.width, left, right, height);
    }
  }
  return 0;
}
