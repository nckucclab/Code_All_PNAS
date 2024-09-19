import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
df = pd.read_excel('FigureA1.xlsx')

year = df['year'].values
q_eiu = df['Q_EIU'].values
eiu = df['EIU'].values
y221 = df['Y221'].values
y223 = df['Y223'].values
y229 = df['Y229'].values
q_pr = df['Q_PR'].values
pr = df['PR'].values
y221p = df['Y221P'].values
y223p = df['Y223P'].values
y229p = df['Y229P'].values

# Only include groups 1 and 4

data221p = { 
    'Group1': {
        'years': year[0:18],
        'political_rights': pr[0:18],
        'internet_Filtering': y221p[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'political_rights': pr[18:36],
#         'internet_Filtering': y221p[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'political_rights': pr[36:54],
#         'internet_Filtering': y221p[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'political_rights': pr[54:72],
        'internet_Filtering': y221p[54:72],
    }
}

data221e = {
    'Group1': {
        'years': year[0:18],
        'democracy_index': eiu[0:18],
        'internet_Filtering': y221[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'democracy_index': eiu[18:36],
#         'internet_Filtering': y221[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'democracy_index': eiu[36:54],
#         'internet_Filtering': y221[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'democracy_index': eiu[54:72],
        'internet_Filtering': y221[54:72],
    }
}

data223p = {
    'Group1': {
        'years': year[0:18],
        'political_rights': pr[0:18],
        'internet_shut_down': y223p[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'political_rights': pr[18:36],
#         'internet_shut_down': y223p[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'political_rights': pr[36:54],
#         'internet_shut_down': y223p[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'political_rights': pr[54:72],
        'internet_shut_down': y223p[54:72],
    }
}

data223e = {
    'Group1': {
        'years': year[0:18],
        'democracy_index': eiu[0:18],
        'internet_shut_down': y223[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'democracy_index': eiu[18:36],
#         'internet_shut_down': y223[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'democracy_index': eiu[36:54],
#         'internet_shut_down': y223[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'democracy_index': eiu[54:72],
        'internet_shut_down': y223[54:72],
    }
}

data229p = {
    'Group1': {
        'years': year[0:18],
        'political_rights': pr[0:18],
        'cyber_security_capacity': y229p[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'political_rights': pr[18:36],
#         'cyber_security_capacity': y229p[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'political_rights': pr[36:54],
#         'cyber_security_capacity': y229p[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'political_rights': pr[54:72],
        'cyber_security_capacity': y229p[54:72],
    }
}

data229e = {
    'Group1': {
        'years': year[0:18],
        'democracy_index': eiu[0:18],
        'cyber_security_capacity': y229[0:18],
    },
#     'Group2': {
#         'years': year[18:36],
#         'democracy_index': eiu[18:36],
#         'cyber_security_capacity': y229[18:36],
#     },
#     'Group3': {
#         'years': year[36:54],
#         'democracy_index': eiu[36:54],
#         'cyber_security_capacity': y229[36:54],
#     },
    'Group4': {
        'years': year[54:72],
        'democracy_index': eiu[54:72],
        'cyber_security_capacity': y229[54:72],
    }
}

# Set gradient color
colors = {
    'Group1': 'Blues',  # Low-scoring group
#     'Group2': 'Purples',
#     'Group3': 'Greens',
    'Group4': 'Reds' # Hight-scoring group
}

plt.figure(figsize=(12, 8))

fig, axs = plt.subplots(3, 2, figsize=(12, 12))

# axs[0, 0].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)
# axs[0, 0].set_xlabel('PR')
# axs[0, 0].set_ylabel('Y221P')
# axs[0, 0].set_title('PR vs. Y221P')

#221p
for group, group_data in data221p.items():
    FH = group_data['political_rights']
    Internet = group_data['internet_Filtering']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))  # Adjust circle diameter range
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[0, 0].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5) # alpha = transparency (solid = 1)

axs[0, 0].set_xlabel("FH's Political Rights")
axs[0, 0].set_ylabel("Content Filtering (CF) Capacity")
# axs[0, 0].set_xlim(-1.5,1.5)
# axs[0, 0].set_ylim(-1, 1.25)
#axs[0, 0].set_title('PR vs. Y223P')
axs[0, 0].grid(True)
#plt.title("Political Rights vs Internet Shut Down Capacity (2006-2023)")

#223p
for group, group_data in data223p.items():
    FH = group_data['political_rights']
    Internet = group_data['internet_shut_down']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[1, 0].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)

axs[1, 0].set_xlabel("FH's Political Rights")
axs[1, 0].set_ylabel("Internet Shut Down (SD) Capacity")
# axs[1, 0].set_xlim(-1.5,1.5)
# axs[1, 0].set_ylim(-1, 1.25)
axs[1, 0].grid(True)

#229p
for group, group_data in data229p.items():
    FH = group_data['political_rights']
    Internet = group_data['cyber_security_capacity']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[2, 0].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)

axs[2, 0].set_xlabel("FH's Political Rights")
axs[2, 0].set_ylabel("Cyber Security (CS) Capacity ")
# axs[2, 0].set_xlim(-1.5,1.5)
# axs[2, 0].set_ylim(-1, 1.25)
axs[2, 0].grid(True)


#221e
for group, group_data in data221e.items():
    FH = group_data['democracy_index']
    Internet = group_data['internet_Filtering']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[0, 1].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)

axs[0, 1].set_xlabel("EIU' s Democracy Index")
axs[0, 1].set_ylabel("Content Filtering (CF) Capacity")
# axs[0, 1].set_xlim(-0.25, 0.2)
# axs[0, 1].set_ylim(-1, 1.25)
axs[0, 1].grid(True)

#223e
for group, group_data in data223e.items():
    FH = group_data['democracy_index']
    Internet = group_data['internet_shut_down']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[1, 1].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)

axs[1, 1].set_xlabel("EIU' s Democracy Index")
axs[1, 1].set_ylabel("Internet Shut Down (SD) Capacity")
# axs[1, 1].set_xlim(-0.25, 0.2)
# axs[1, 1].set_ylim(-1, 1.25)
axs[1, 1].grid(True)

#229e
for group, group_data in data229e.items():
    FH = group_data['democracy_index']
    Internet = group_data['cyber_security_capacity']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        axs[2, 1].scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5)

axs[2, 1].set_xlabel("EIU' s Democracy Index")
axs[2, 1].set_ylabel("Cyber Security (CS) Capacity ")
# axs[2, 1].set_xlim(-0.25, 0.2)
# axs[2, 1].set_ylim(-1, 1.25)
axs[2, 1].grid(True)

fig.savefig('Figure A1.png')

##### The following is a single set of images test #####

# Plot the data
for group, group_data in data221p.items():
    FH = group_data['political_rights']
    Internet = group_data['internet_Filtering']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))  # Adjust circle diameter range
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        plt.scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5) # alpha = transparency (solid = 1)

plt.xlabel("FH's Political Rights")
plt.ylabel("Internet Filtering Capacity")
plt.xlim(-1.5, 1.5)
# plt.ylim(-1, 1.2)

#plt.title("Political Rights vs Internet Shut Down Capacity (2006-2023)")

plt.grid(True)
#plt.legend()
plt.savefig('data221p.png')
plt.show()

# Plot the data
for group, group_data in data229e.items():
    FH = group_data['democracy_index']
    Internet = group_data['cyber_security_capacity']
    years = group_data['years']
    sizes = np.linspace(5, 300, len(years))  # Adjust circle diameter range
   
    cmap = plt.get_cmap(colors[group])
    norm = plt.Normalize(years.min(), years.max())
   
    for i in range(len(years)):
        plt.scatter(FH[i], Internet[i], s=sizes[i], color=cmap(norm(years[i])), alpha=0.9, edgecolors='w', linewidth=0.5) # alpha = transparency (solid = 1)

plt.xlabel("EIU' s Democracy Index")
plt.ylabel("Cyber Security Capacity")
plt.xlim(-0.25, 0.25)
# plt.ylim(-1, 1.2)
#plt.title("Political Rights vs Internet Shut Down Capacity (2006-2023)")

plt.grid(True)
plt.savefig('data229ep.png')
plt.show()