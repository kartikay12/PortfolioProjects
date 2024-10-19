import pandas as pd
import matplotlib.pyplot as plt


#Paste these lines seprately and run on seprately your jupyter


df =pd.read_csv("data\colors.csv")
df.head()
#

df['name'].nunique()

#

df.is_trans.value_counts()

#

sets=pd.read_csv("data\sets.csv")
sets.head()

#

sets[sets['year']==1949]

#

sets.sort_values('num_parts',ascending=False).head()

#

sets_by_year=sets.groupby('year').count()

#

sets_by_year['set_num'].tail()

#


plt.plot(sets_by_year.index, sets_by_year.set_num)

#

plt.plot(sets_by_year.index[:-2], sets_by_year.set_num[:-2])

#

themes_by_year = sets.groupby('year').agg({'theme_id': pd.Series.nunique})

#

themes_by_year.rename(columns={'theme_id':'nr_themes'},inplace=True)
themes_by_year.head()

#

themes_by_year.tail()

#

plt.plot(themes_by_year.index[:-2],themes_by_year.nr_themes[:-2])

#

ax1 = plt.gca()
ax2 = ax1.twinx()
ax2.plot(themes_by_year.index[:-2],themes_by_year.nr_themes[:-2],color = 'Blue')
ax1.plot(sets_by_year.index[0:-2],sets_by_year.set_num[:-2],color = 'Green')

ax1.set_label('Year')
ax1.set_ylabel('Number of Sets',color = 'Green')
ax2.set_ylabel('Number of Themes',color = 'blue')

#
parts_per_set = sets.groupby('year').agg({'num_parts': pd.Series.mean})
parts_per_set.head()

#
parts_per_set.tail()

#
plt.scatter(parts_per_set.index[:-2], parts_per_set.num_parts[:-2])

#

set_theme_count = sets["theme_id"].value_counts()
set_theme_count[:5]

#

themes = pd.read_csv('data/themes.csv') # has the theme names!
themes.head()

#

themes[themes.name == 'Star Wars']

#

sets[sets.theme_id == 18]

#

sets[sets.theme_id == 209]


set_theme_count = pd.DataFrame({'id':set_theme_count.index, 
                                'set_count':set_theme_count.values})
set_theme_count.head()


#

merged_df = pd.merge(set_theme_count, themes, on='id')
merged_df[:3]

#

plt.figure(figsize=(14,8))
plt.xticks(fontsize=14, rotation=45)
plt.yticks(fontsize=14)
plt.ylabel('Nr of Sets', fontsize=14)
plt.xlabel('Theme Name', fontsize=14)

plt.bar(merged_df.name[:10], merged_df.set_count[:10])
