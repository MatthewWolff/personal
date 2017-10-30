import sys


def find_neighbors(n):
    n_neighs = []
    for n_neigh in range(0, len(n)):
        if n[n_neigh] is 1:
            n_neighs.append(n_neigh)
    return n_neighs


# f = open(s, 'rb') # replaced f. with sys.stdin.
while 1:
    # read in
    node_num = int(sys.stdin.readline())
    if node_num is -1:
        exit(0)
    adjacency_matrix = []
    for node in range(0, node_num):
        node_adjacency = sys.stdin.readline().replace("\n", "").split(" ")
        node_adjacency = [int(i) for i in node_adjacency]
        adjacency_matrix.append(node_adjacency)

    # decide if triangular
    non_tri = []
    for this_node in range(0, node_num):
        node = adjacency_matrix[this_node]

        neighbors = find_neighbors(node)

        # neighbor check for auto-disqualify
        if len(neighbors) < 2:
            non_tri.append(str(this_node))
            continue
        # find if it completes a triangle
        triangle_made = False
        for neigh in neighbors:
            their_neighbors = find_neighbors(adjacency_matrix[neigh])
            for node in their_neighbors:
                if this_node in find_neighbors(adjacency_matrix[node]):
                    triangle_made = True
        if not triangle_made:
            non_tri.append(str(this_node))

    print " ".join(non_tri)
