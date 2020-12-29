# `exp2gauss.m`

## Lines 45-47:
$$
f_1(x) = \frac{\tau_g^2}{2\tau_1} - \frac{x-\tau_{\Delta}}{\tau_1}
$$

$$
g_1(x) = \frac{\tau_g^2-\tau_1(x-\tau_{\Delta})}{\sqrt{2}\tau_1\tau_g}
$$

$$
y_1 = \beta_1e^{f_1(x)}, \ y_2 = \text{erfc}(g_1(x))
$$

$$
y = \beta_1e^{f_1(x)}\text{erfc}(g_1(x))
$$

## Lines 50-54:
$$
f_2(x) = \frac{\tau_g^2}{2\tau_1} - \frac{x-\tau_{\Delta}+P}{\tau_1}
$$

$$
g_2(x) = \frac{\tau_g^2-\tau_1(x-\tau_{\Delta}+P)}{\sqrt{2}\tau_1\tau_g}
$$

$$
y_1 = \beta_1e^{f_2(x)}, \ y_2 = \text{erfc}(g_2(x))
$$

$$
y_a = \frac{1}{2}\left(\beta_1e^{f_2(x)}\text{erfc}(g_2(x)) + \beta_1e^{f_1(x)}\text{erfc}(g_1(x))\right)
$$

## Lines 56-58:
$$
f_3(x) = \frac{\tau_g^2}{2\tau_2} - \frac{x-\tau_{\Delta}}{\tau_2}
$$

$$
g_3(x) = \frac{\tau_g^2-\tau_2(x-\tau_{\Delta})}{\sqrt{2}\tau_2\tau_g}
$$

$$
y_1 = \beta_3e^{f_3(x)}, \ y_2 = \text{erfc}(g_3(x))
$$

$$
y = \beta_3e^{f_3(x)}\text{erfc}(g_3(x))
$$

## Lines 60-64:
$$
f_4(x) = \frac{\tau_g^2}{2\tau_2} - \frac{x-\tau_{\Delta}+P}{\tau_2}
$$

$$
g_4(x) = \frac{\tau_g^2-\tau_2(x-\tau_{\Delta}+P)}{\sqrt{2}\tau_2\tau_g}
$$

$$
y_1 = \beta_3e^{f_4(x)}, \ y_2 = \text{erfc}(g_4(x))
$$

$$
y_b = \frac{1}{2}\left(\beta_3e^{f_4(x)}\text{erfc}(g_4(x)) + \beta_3e^{f_3(x)}\text{erfc}(g_3(x))\right)
$$

## Full Equation

$$
y = y_a + y_b
$$

$$
y_a = \frac{1}{2}\left(\beta_1\exp\left({\frac{\tau_g^2}{2\tau_1} - \frac{x-\tau_{\Delta}+P}{\tau_1}}\right)\text{erfc}\left(\frac{\tau_g^2-\tau_1(x-\tau_{\Delta}+P)}{\sqrt{2}\tau_1\tau_g}\right) + \beta_1\exp\left({\frac{\tau_g^2}{2\tau_1} - \frac{x-\tau_{\Delta}}{\tau_1}}\right)\text{erfc}\left(\frac{\tau_g^2-\tau_1(x-\tau_{\Delta})}{\sqrt{2}\tau_1\tau_g}\right)\right)
$$

$$
\text{erfc}(x) = 1 - \frac{2}{\sqrt{\pi}} \int_{0}^{x}e^{-t^2}dt
$$