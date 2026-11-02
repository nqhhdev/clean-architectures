One file per term. Each section groups terms by subject (the first tag).

# architecture
* [Layer](layer.md) - A group of code with one role and a fixed list of layers it may import.
* [Repository](repository.md) - The single source of truth for one kind of data; hides services, DTOs and caching behind an interface.
* [State Holder](state-holder.md) - The object that holds a screen's state and actions: a view model, bloc, controller or notifier.

# configuration
* [Flavor](flavor.md) - One build variant of the app per environment, with its own config, id and backend.

# testing
* [Golden Test](golden-test.md) - A widget test that compares a rendered image with a stored reference; canonical on Linux/CI.
