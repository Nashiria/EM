const double dx = 1;
const double dt = 0.1;
const int N = 100;
var halfN = N ~/ 2;

void main() {
  var hz = ones(N + 1, 0);
  var ey = ones(N + 1, 0);
  ey[halfN] = 1;

  for (int t = 0; t < 200; t++) {
    hz = hzUpdate(ey, hz);
    ey = eyUpdate(ey, hz);
    print(hz);
  }
}

double exp(double arg) {
  return 1 + arg * (1 + arg *(1 / 2 + arg * (1 / 6 + arg * (1 / 24 * arg * (1 / 120 + arg * (1 / 720))))));
}

List<double> ones(int size, double fill) {
  return List<double>.filled(size, fill);
}

List<double> hzUpdate(List<double> ey, List<double> hz) {
  ey[0] = 0;
  ey[N] = 0;
  var hzTemp = ones(hz.length, 0);
  for (int i = 0; i < hz.length; i++) {
    int index = i + 1;
    if (index > hz.length - 1) {
      index = 0;
    }
    hzTemp[i] = hz[i] + (dt / dx) * (ey[index] - ey[i]);
  }
  return hzTemp;
}

List<double> eyUpdate(List<double> ey, List<double> hz) {
  hz[0] = 0;
  hz[N] = 0;
  var eyTemp = ones(ey.length, 0);
  for (int i = 1; i < ey.length; i++) {
    int index = i - 1;
    if (index < 0) {
      index = ey.length - 1;
    }
    eyTemp[i] = ey[i] + (dt / dx) * (hz[i] - hz[index]);
  }
  return eyTemp;
}
