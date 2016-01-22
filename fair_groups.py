import numpy as np
from itertools import product

class Person(object):
  def __init__(self, age, weight, skill, self_skill, school, willing_to_fight_higher):
    self.age = age
    self.weight = weight
    self.skill = skill
    self.self_skill = self_skill
    self.school = school
    self.willing_to_fight_higher = willing_to_fight_higher

def metric(person1, person2):
  return 1
  
def group_metric(group1, group2):
  #The max distance between two people from either group
  return max(metric(p1, p2) for p1, p2 in product(group1, group2))

def group(people):

  while True: #figure out stopping criterion later
    groups = [[person] for person in people]
    n = len(groups)
  
    #Make the distance matrix
    X = np.zeros((n, n))-1
    for i in xrange(n):
      for j in xrange(i+1, n):
        if len(groups[i]) == 4:
        X[i,j] = group_metric(groups[i], groups[j])
  
    #OK, do a merging
  
    #Always choose the one that's farthest from all others. Merge that one with its closest neighbor
  
  return groups