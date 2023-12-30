# robogames-2024


## The math behind the caterpillar tracks
### Setup
The caterpillar tracks move along a Path3D node's curve. There are four rollers with positions $\vec{p_1}, \vec{p_2}, \vec{p_3}, \vec{p_4}$ and radii $r_1, r_2, r_3, r_4$ used to define the curve control points.\
Additionally, there is a parameter $q$ which controls how much the curve droops betweem the top two rollers.\

### Computing the control points
First, compute the vectors $\vec{l_i}$ by subtracting the rollers' positions.
$$\vec{l_i} = \vec{p_{i+1}} - \vec{p_i} $$
$$so$$
$$\vec{l_1} = \vec{p_2} - \vec{p_1} $$
$$\vec{l_2} = \vec{p_3} - \vec{p_2} $$
$$\vec{l_3} = \vec{p_4} - \vec{p_3} $$
$$\vec{l_4} = \vec{p_1} - \vec{p_4} $$
The lengths should only take the y-z plane into account, so we will set $l_i.x=0$ (ideally, the roller positions all lie in the same y-z plane).


Compute the angles $\alpha_i$.
$$\alpha_i = cos^{-1}{r_i - r_{i+1}  \over \|\vec{l_i}\|} $$
$$so$$
$$\alpha_1 = cos^{-1}{r_1 - r_2  \over \|\vec{l_1}\|} $$
$$\alpha_2 = cos^{-1}{r_2 - r_3  \over \|\vec{l_2}\|} $$
$$\alpha_3 = cos^{-1}{r_3 - r_4  \over \|\vec{l_3}\|} $$
$$\alpha_4 = cos^{-1}{r_4 - r_1  \over \|\vec{l_4}\|} $$


Compute the angles between rollers $\beta_i$.
$$\beta_i = tan^{-1} {\vec{l_i}.y \over \vec{l_i}.z}$$
$$so$$
$$\beta_1 = tan^{-1} {\vec{l_1}.y \over \vec{l_1}.z}$$
$$\beta_2 = tan^{-1} {\vec{l_2}.y \over \vec{l_2}.z}$$
$$\beta_3 = tan^{-1} {\vec{l_3}.y \over \vec{l_3}.z}$$
$$\beta_4 = tan^{-1} {\vec{l_4}.y \over \vec{l_4}.z}$$


Compute the positions of the control points that lie on the outer edge of the rollers $\vec{u_i}, \vec{v_i}$.
$$\vec{u_i} = r_i  \langle 0, sin(\beta_{i-1} + \alpha_{i-1}), cos(\beta_{i-1} + \alpha_{i-1}) \rangle$$
$$\vec{v_i} = r_i  \langle 0, sin(\beta_i + \alpha_i), cos(\beta_i + \alpha_i) \rangle$$
$$so$$
$$\vec{u_1} = r_1  \langle 0, sin(\beta_4 + \alpha_4 + q), cos(\beta_4 + \alpha_4 + q) \rangle$$
$$\vec{v_1} = r_1  \langle 0, sin(\beta_1 + \alpha_1), cos(\beta_1 + \alpha_1) \rangle$$
$$\vec{u_2} = r_2  \langle 0, sin(\beta_1 + \alpha_1), cos(\beta_1 + \alpha_1) \rangle$$
$$\vec{v_2} = r_2  \langle 0, sin(\beta_2 + \alpha_2), cos(\beta_2 + \alpha_2) \rangle$$
$$\vec{u_3} = r_3  \langle 0, sin(\beta_2 + \alpha_2), cos(\beta_2 + \alpha_2) \rangle$$
$$\vec{v_3} = r_3  \langle 0, sin(\beta_3 + \alpha_3), cos(\beta_3 + \alpha_3) \rangle$$
$$\vec{u_4} = r_4  \langle 0, sin(\beta_3 + \alpha_3), cos(\beta_3 + \alpha_3) \rangle$$
$$\vec{v_4} = r_4  \langle 0, sin(\beta_4 + \alpha_4 - q), cos(\beta_4 + \alpha_4 - q) \rangle$$
Note: for $\vec{u_1}$ and $\vec{v_4}$, the droop factor $q$ is included the the positional computation as well.

Compute $n_i$, the number of circular arcs with angle $\beta_i - \alpha_i$ that make up a whole circle ($n_i$ also includes fractional segments).\
$$n_i = {2\pi \over (\beta_{i-1} + \alpha_{i-1}) - (\beta_i + \alpha_i)}$$
$$so$$
$$n_1 = {2\pi \over (\beta_4 + \alpha_4 + q) - (\beta_1 + \alpha_1)}$$
$$n_2 = {2\pi \over (\beta_1 + \alpha_1) - mod(\beta_2 + \alpha_2, 2\pi) - 2\pi}$$
$$n_3 = {2\pi \over mod(\beta_2 + \alpha_2,2\pi) - (\beta_3 + \alpha_3)}$$
$$n_4 = {2\pi \over (\beta_3 + \alpha_3) - (\beta_4 + \alpha_4 - 1)}$$
Note: the divisor term $(\beta_1 + \alpha_1)$ is wrapped, so that it does not change sign when the height difference between roller 2 and 3 changes sign.

Compute $k_i$, the tangent handle length for a bezier segment on a given roller.
$$k_i = {4 \over 3} tan{\pi \over 2 n_i}$$
$$so$$
$$k_1 = {4 \over 3} tan({\pi \over 2 n_1} )$$
$$k_2 = {4 \over 3} tan({\pi \over 2 n_2} )$$
$$k_3 = {4 \over 3} tan({\pi \over 2 n_3} )$$
$$k_4 = {4 \over 3} tan({\pi \over 2 n_4} )$$

Compute $\vec{f_i}, \vec{g_i}$, the outgoing and incoming relative tangent positions of a given roller.
$$\vec{f_i} = k_i \langle 0, -\vec{u_i}.z, \vec{u_i}.y \rangle$$
$$\vec{g_i} = k_i \langle 0, \vec{v_i}.z, -\vec{v_i}.y \rangle$$
$$so$$
$$\vec{f_1} = k_1 \langle 0, -\vec{u_1}.z, \vec{u_1}.y \rangle$$
$$\vec{g_1} = k_2 \langle 0, \vec{v_1}.z, -\vec{v_1}.y \rangle$$
$$\vec{f_2} = k_2 \langle 0, -\vec{u_2}.z, \vec{u_2}.y \rangle$$
$$\vec{g_2} = k_2 \langle 0, \vec{v_2}.z, -\vec{v_2}.y \rangle$$
$$\vec{f_3} = k_3 \langle 0, -\vec{u_3}.z, \vec{u_3}.y \rangle$$
$$\vec{g_3} = k_3 \langle 0, \vec{v_3}.z, -\vec{v_3}.y \rangle$$
$$\vec{f_4} = k_4 \langle 0, -\vec{u_4}.z, \vec{u_4}.y \rangle$$
$$\vec{g_4} = k_4 \langle 0, \vec{v_4}.z, -\vec{v_4}.y \rangle$$
