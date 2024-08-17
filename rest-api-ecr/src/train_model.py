from sklearn.datasets import fetch_lfw_people
from sklearn.neighbors import NearestNeighbors
import numpy as np
from joblib import dump


def train_model():
    face_data = fetch_lfw_people(min_faces_per_person=5)

    X = face_data.data
    labels = face_data.target  # numeric labels corresponding to individuals
    names = face_data.target_names  # names corresponding to numeric labels
    names_to_labels = {}
    labels_to_names = {}

    for index, names_idx in enumerate(labels):
        name = names[names_idx]
        if name in names_to_labels:
            names_to_labels[name].append(index)
        else:
            names_to_labels[name] = [index]

        labels_to_names[index] = names[labels[index]]

    nn_model = NearestNeighbors(n_neighbors=15)
    nn_model.fit(X, labels)

    dump(nn_model, "nn_model.joblib", compress=3)
    np.save("feature_matrix.npy", X)
    np.save("names_to_labels.npy", names_to_labels)
    np.save("labels_to_names.npy", labels_to_names)


if __name__ == "__main__":

    train_model()
