# robogames-2024


## The math behind the caterpillar tracks
### Setup
The caterpillar tracks move along a Path3D node's curve. There are four rollers with positions $\vec{p_1}, \vec{p_2}, \vec{p_3}, \vec{p_4}$ and radii $r_1, r_2, r_3, r_4$ used to define the curve control points.\
Additionally, there is a parameter $q$ which controls how much the curve droops across the top two rollers.\

### Computing the control points
First, compute the vectors $\vec{l_1}, \vec{l_2}, \vec{l_3}, \vec{l_4}$ by subtracting the rollers' positions. \
$$\vec{l_1} = \vec{p_2} - \vec{p_1} $$
$$\vec{l_2} = \vec{p_3} - \vec{p_2} $$
$$\vec{l_3} = \vec{p_4} - \vec{p_3} $$
$$\vec{l_4} = \vec{p_1} - \vec{p_4} $$
The lengths should only take the y-z plane into account, so we will set the x component to zero (ideally, the roller positions all lie in the same y-z plane).

Compute the angles $\alpha_1, \alpha_2, \alpha_3$.
$$\alpha_1 = {r_1 - r_2  \over \|\vec{l_1}\|} $$
$$\alpha_2 = {r_2 - r_3  \over \|\vec{l_2}\|} $$
$$\alpha_3 = {r_3 - r_4  \over \|\vec{l_3}\|} $$

Compute the angles between rollers $\beta_1, \beta_2, \beta_3$.
$$\beta_1 = tan^{-1} {\vec{l_1}.y \over \vec{l_1}.z}$$
$$\beta_2 = tan^{-1} {\vec{l_2}.y \over \vec{l_2}.z}$$
$$\beta_3 = tan^{-1} {\vec{l_3}.y \over \vec{l_3}.z}$$

Compute the positions of the control points that lie on the outer edge of the rollers $\vec{v_1}, \vec{u_2}, \vec{v_2}, \vec{u_3}, \vec{v_3}, \vec{u_4}$ (control points $\vec{u_1}$ and $\vec{v_4}$ connect the droop curve and will be computed later on).
$$\vec{v_1} = r_1  \langle 0, sin(\beta_1 - \alpha_1), cos(\beta_1 - \alpha_1) \rangle$$
$$\vec{u_2} = r_2  \langle 0, sin(\beta_1 - \alpha_1), cos(\beta_1 - \alpha_1) \rangle$$
$$\vec{v_2} = r_2  \langle 0, sin(\beta_2 - \alpha_2), cos(\beta_2 - \alpha_2) \rangle$$
$$\vec{u_3} = r_3  \langle 0, sin(\beta_2 - \alpha_2), cos(\beta_2 - \alpha_2) \rangle$$
$$\vec{v_3} = r_3  \langle 0, sin(\beta_3 - \alpha_3), cos(\beta_3 - \alpha_3) \rangle$$
$$\vec{u_4} = r_4  \langle 0, sin(\beta_3 - \alpha_3), cos(\beta_3 - \alpha_3) \rangle$$
