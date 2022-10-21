from git import Repo
import os

repo = Repo(".")

for x in os.walk(""):
    print(x[0])

# x = "abc /pipeline hehe/".replace("/", "")
# print(x)