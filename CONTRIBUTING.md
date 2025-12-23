# Contributing to Art of Evolve

Thank you for your interest in contributing to Art of Evolve! We welcome all kinds of contributions, from bug fixes to new features.

## How to Contribute

### Reporting Bugs

If you find a bug, please report it! Open a new issue and include:
- A clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

### Making Changes

1.  **Fork the Repository**: Create a personal fork of the project on GitHub.
2.  **Clone the Fork**: Clone your fork to your local machine.
3.  **Create a Branch**: Create a new branch for your changes.
    ```bash
    git checkout -b feature/my-new-feature
    ```
4.  **Make Changes**: Implement your changes and ensure the code follows our style guidelines.
5.  **Run Tests**: Ensure all tests pass before submitting.
    ```bash
    flutter test
    ```
6.  **Run Analysis**: Ensure there are no lint issues.
    ```bash
    flutter analyze
    ```
7.  **Commit Changes**: Commit your changes with a descriptive message.
8.  **Push to GitHub**: Push your changes to your fork.
9.  **Submit a Pull Request**: Submit a pull request to the main repository.

## Coding Style

- Use single quotes for strings where possible.
- Ensure all public APIs have documentation comments.
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/analysis-options).
- Use `const` constructors wherever possible.

## Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries such as documentation generation

Example: `feat: add new habit tracker widget`

## Project Structure

This project follows a feature-first architecture:

- `lib/src/core`: Core utilities, theme, and constants.
- `lib/src/features`: Feature-based modules (e.g., `auth`, `home`, `self_care`).
- `test`: Unit and widget tests mirroring the `lib` structure.

## Community

Join our community to discuss features and get help! [Visit our Discord](https://discord.gg/artofevolve)
