import sys
import os
import heapq # my dijkstra implementation #TODO: Remove
import string
from colorama import Fore, Style, init
import networkx as nx

# Global variables
words = set()
anagrams = {}
G = nx.DiGraph()

# COST CONFIGURATION
add_cost :int = 1
del_cost :int = 1
sub_cost :int = 2
ang_cost :int = 1

# Labels for the results
add_label :str = 'Add'
del_label :str = 'Del'
sub_label :str = 'Sub'
ang_label :str = 'Ang'

ok_log_init = '[' + Fore.LIGHTGREEN_EX + 'OK' + Style.RESET_ALL + '] '
expired_log_init = '[' + Fore.LIGHTRED_EX + 'Expired' + Style.RESET_ALL + '] '

def get_adjacencies(word :str, final :str) -> list[str]:
	global words
	global anagrams
	global add_cost
	global del_cost
	global sub_cost
	global ang_cost
	global add_label
	global del_label
	global sub_label
	global ang_label

	result = []
	tuple_ang_list = []

	# add
	for i in range(len(word)+1):
		for c in string.ascii_lowercase:
			new_word = word[:i] + c + word[i:]
			if (new_word in words or new_word == final):
				result.append((new_word, add_cost, add_label))

	# del
	for i in range(len(word)):
		new_word = word[:i] + word[i+1:]
		if new_word in words or new_word == final:
			result.append((new_word, del_cost, del_label))

	# sub
	for i in range(len(word)):
		for c in string.ascii_lowercase:
			if c != word[i]:
				new_word = word[:i] + c + word[i+1:]
			if new_word in words or new_word == final:
				result.append((new_word, sub_cost, sub_label))

	# ang
	try:
		ang_list = anagrams[''.join(sorted(word))]

		if(sorted(word) == sorted(final)):
			ang_list.append(final)
		for w in ang_list:
			tuple_ang_list.append((w, ang_cost, ang_label))
		result = [*result, *tuple_ang_list]
	except KeyError:
		pass

	return result

#TODO: Remove
def dijkstra(initial :str, final :str) -> list[str]:
	global words
	global G

	distances = {}
	predecessors = {}
	result = []

	for w in words:
		distances[w] = float('inf')
		predecessors[w] = None

	distances[initial] = 0
	predecessors[initial] = None
	distances[final] = float('inf')
	predecessors[final] = None

	queue = []
	heapq.heappush(queue, (0, initial))

	while queue:
		distance, word = heapq.heappop(queue)
		if word == final:
			single_path = []
			while word is not None:
				single_path.append(word)
				word = predecessors[word]
			return single_path[::-1]

		for neighbor in get_adjacencies(word, final):
			new_distance = distance + 1
			if new_distance < distances[neighbor]:
				distances[neighbor] = new_distance
				predecessors[neighbor] = word
				heapq.heappush(queue, (new_distance, neighbor))

	return result

def build_graph(initial :str, final :str):
	global words
	global G

	for w in words:
		for (adj, cost, label) in get_adjacencies(w, final):
			G.add_edge(w, adj, weight=cost, op=label)

	if initial not in words:
		for (adj, cost, label) in get_adjacencies(initial, final):
			G.add_edge(initial, adj, weight=cost, op=label)

if __name__ == '__main__':
	# colorama module initialization
	init(autoreset=True)

	initial_word :str = ''
	final_word :str = ''

	# clearing previous shell output
	os.system('clear')

	# get dictionary and user input
	words_file = open('data/words.italian.txt', 'r')
	for line in words_file:
		if line != '\n':
			w = line.strip().lower()
			key = ''.join(sorted(w))
			words.add(w)
			G.add_node(w)
			if key in anagrams:
				anagrams[key].append(w)
			else:
				anagrams[key] = [w]

	if len(sys.argv) == 3:
		initial_word = sys.argv[1]
		final_word = sys.argv[2]
	else:
		initial_word = input('1: ').lower()
		final_word = input('2: ').lower()

	G.add_node(initial_word)
	G.add_node(final_word)

	# Printing cost configuration
	print(ok_log_init + 'Cost configuration: ')
	print('Addition = %d' % (add_cost))
	print('Deletion = %d' % (del_cost))
	print('Substitution = %d' % (sub_cost))
	print('Anagram: %d' % (ang_cost))

	# Building graph edges
	print(ok_log_init + 'Building graph [10 seconds]... ', end='')
	build_graph(initial_word, final_word)
	print('Done!')

	# Finding the best paths
	print(ok_log_init + 'Finding all the best paths...', end='')
	alternative_paths = []
	best_paths = []
	paths = []

	for path in nx.all_shortest_paths(G, source=initial_word, target=final_word):
		paths.append(path)

	# Get the minimum cost
	min_path_cost :int = 10000 # it is impossible to reach
	for path in paths:
		details = nx.path_graph(path)
		total_cost :int = 0
		for edge in details.edges():
			edge_details = G.edges[edge[0], edge[1]]
			total_cost = total_cost + edge_details['weight']
		if total_cost < min_path_cost:
			min_path_cost = total_cost

	# Divide best and alternative paths
	for path in paths:
		details = nx.path_graph(path)
		total_cost :int = 0
		for edge in details.edges():
			edge_details = G.edges[edge[0], edge[1]]
			total_cost = total_cost + edge_details['weight']
		if total_cost == min_path_cost:
			best_paths.append(path)
		else:
			alternative_paths.append(path)

	print('Done!')

	# Print suboptimal paths and their cost
	# Suboptimal paths are the paths with the same number of operations as the best path
	# but with an higher cost
	if len(alternative_paths) > 1:
		print(ok_log_init + 'Here are some paths you can use [' + Fore.LIGHTRED_EX \
				  + 'suboptimal' + Style.RESET_ALL + ']: ')
	elif len(alternative_paths) == 1:
		print(ok_log_init + 'This is a possible path you can use [' + Fore.LIGHTRED_EX \
				  + 'suboptimal' + Style.RESET_ALL + ']: ')
	else:
		print(ok_log_init + 'I cannot find suboptimal paths with the same number of steps as the best path.')

	for path in alternative_paths:
		print(path, end='\t')
		details = nx.path_graph(path)
		total_cost :int = 0
		for edge in details.edges():
			edge_details = G.edges[edge[0], edge[1]]
			total_cost = total_cost + edge_details['weight']
		print('Total cost: %d' % (total_cost))

	print()

	# Print best paths with their operations and cost
	if len(best_paths) > 1:
		print(ok_log_init + 'The following are the best possible paths and they are all equivalent: ')
	elif len(best_paths):
		print(ok_log_init + 'This is the best path possible, you cannot find existing alternatives with the same cost: ')

	for path in best_paths:
		print()
		print(path)
		details = nx.path_graph(path)
		print('Operations:')
		total_cost :int = 0
		for edge in details.edges():
			edge_details = G.edges[edge[0], edge[1]]
			total_cost = total_cost + edge_details['weight']
			print('\t', edge, G.edges[edge[0], edge[1]]['op'])
		print('Total cost: %d' % (total_cost))

