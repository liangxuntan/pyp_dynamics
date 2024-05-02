# Reconstructing femotosecond dynamics of a photoactive protein using machine learning

This is a matlab-based manifold machine learning framework based on non-linear Laplacian spectral analysis. In particular, the method uses time-lagged embedding to project diffraction time-series onto a n-dimensional manifold to model the trajectory of electron density changes.

## Documentation

* Input PYP light and dark states SFX data from : a) raw data from link in base_pyprun/readme b) linear combination of structure factors of pyp light and dark state c) inject gaussian noise and reorder snapshots in rawdata to simulate timing jitter in SFX experiments

* (makescripts) Generate scripts for running NLSA code on servers: makescripts and copy to basefolder/NLSA and basefolder/sna/release/2.0/variations

* (makemaps) Create difference-electron density movies: copy .hkls from NLSA to makemaps/inputhkl

* (examples) Contains sample runs

## References
"Few-femtosecond resolution of a photoactive protein traversing a conical intersection", A. Hosseinizadeh et al., Nature 599, 697-701 (2021)
