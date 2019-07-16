import random

with open('aaa/train.txt', 'w+') as file:
    for line in range(30000):
        for word in range(10):
            file.write('a ')
        file.write('\n')

with open('aaa/valid.txt', 'w+') as file:
    for line in range(100):
        for word in range(10):
            file.write('a ')
        file.write('\n')

with open('aaa/test.txt', 'w+') as file:
    for line in range(5000):
        for word in range(10):
            file.write('a ')
        file.write('\n')

with open('aba/train.txt', 'w+') as file:
    for line in range(30000):
        for word in range(10):
            file.write(random.choice(['a','b']) + ' ')
        file.write('\n')

with open('aba/valid.txt', 'w+') as file:
    for line in range(100):
        for word in range(10):
            file.write(random.choice(['a','b']) + ' ')
        file.write('\n')

with open('aba/test.txt', 'w+') as file:
    for line in range(5000):
        for word in range(10):
            file.write(random.choice(['a','b']) + ' ')
        file.write('\n')
