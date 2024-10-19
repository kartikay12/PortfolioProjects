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