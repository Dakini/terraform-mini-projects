from joblib import load
import numpy as np
from collections import Counter


def classify(input_name):
    nn_model = load("nn_model.joblib")
    X = np.load("feature_matrix.npy")
    names_to_labels = np.load("names_to_labels.npy", allow_pickle=True).item()
    labels_to_names = np.load("labels_to_names.npy", allow_pickle=True).item()

    if input_name not in names_to_labels:
        print(f"{input_name} not found in dataset.")
        return []

    name_record_indices = names_to_labels[input_name]
    input_samples = X[name_record_indices]

    distances, indices = nn_model.kneighbors(input_samples, n_neighbors=15)
    index_distance_tuples = [
        (idx, dist)
        for dists, idxs in zip(distances, indices)
        for idx, dist in zip(idxs, dists)
    ]

    counter = Counter(index_distance_tuples)
    most_common_tuples = counter.most_common(15)
    sorted_indices_by_distance = [
        idx for idx, _ in sorted(most_common_tuples, key=lambda x: x[1])
    ]
    nearest_neighbors_names = [
        labels_to_names[idx] for idx, _ in sorted_indices_by_distance
    ]

    return nearest_neighbors_names


if __name__ == "__main__":
    classify("Vanessa Redgrave")
