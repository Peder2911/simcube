import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import pandas as pd

d = pd.read_csv("data/simulated.csv")

logitToProb = lambda x: np.exp(x) / (1 + np.exp(x))

values = {
    "X" : d.lfree_fair_elections.to_numpy(),
    "Y" : d.lhorizontal_constraint_narrow.to_numpy(),
    "Z" : d.sim_mean.to_numpy(),
}

sqrt = int(np.sqrt(values["X"].shape[0]))
print(sqrt)

values = {k:v.reshape(sqrt,sqrt) for k,v in values.items()}
values["Z"] = logitToProb(values["Z"])

plt3d = plt.figure().gca(projection = "3d")
plt3d.plot_wireframe(**values)
ax = plt.gca()
ax.view_init(25,50)
plt.savefig("/tmp/view.png")
