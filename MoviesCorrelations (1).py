#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np
import re

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create

# Read in the data

df = pd.read_csv('movies.csv')


# In[162]:


# Lets look at the data

df.head()


# In[34]:


# Lets see if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[150]:


# Data types for our columns

df.dtypes


# In[168]:


df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')

# Here we find some values Na or inf, we need to clean these values


# In[156]:


df.head(10)


# In[194]:


#Drop non applicable values from the data and convert to int64
df.dropna(subset=['budget'], inplace=True)
df['budget'] = df['budget'].astype('int64')

df.dropna(subset=['gross'], inplace=True)
df['gross'] = df['gross'].astype('int64')

df.dropna(subset=['votes'], inplace=True)
df['votes'] = df['votes'].astype('int64')

df.dropna(subset=['name'], inplace=True)
df['name'] = df['name'].astype('string')

#date_only = date_object.date()



#df['released'] = pd.to_datetime(df['released'])

# Change the format to 'yyyy-mm-dd'
#df['released'] = df['released'].dt.strftime('%Y-%m-%d')

df.head(10)


# In[196]:


#df.drop('yearcorrect', axis=1, inplace=True)
df.drop('released_year', axis=1, inplace=True)


# In[198]:


df.head()


# In[200]:


df = df.sort_values(by = ['gross'], inplace=False, ascending=False)
df.head()


# In[202]:


# Drop any duplicates

df['company'].drop_duplicates().sort_values(ascending=False)


# In[84]:


pd.set_option('display.max_rows', None)


# In[204]:


# Scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Gross Earnings')

plt.ylabel('Budget for Film')

plt.show()


# In[100]:


df.head()


# In[206]:


# Plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "orange"}, line_kws={"color":"green"})


# In[ ]:


# Lets start looking at correlation


# In[210]:


df['name'] = pd.to_numeric(df['name'], errors='coerce')


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes

df_numerized
df.corr(method='spearman') #pearson, kendall, spearman


# In[212]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[214]:


# Looks at Company

df.head()


# In[220]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes

df_numerized.head(10)


# In[222]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[224]:


df_numerized.corr()


# In[232]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[238]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs

