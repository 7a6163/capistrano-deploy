# Capistrano Deploy

A lightweight Docker container for running Capistrano deployments for Ruby on Rails applications. This project provides a containerized environment with all necessary tools and dependencies.

## Features

- Based on Ruby 3.3 Alpine Linux for minimal image size
- Pre-installed Capistrano with commonly used plugins
- Built-in SSH client and Git support
- Automatic SSH Agent initialization
- Multi-platform support (amd64/arm64)

## Included Gems

- `capistrano` (3.19) - Core deployment tool
- `capistrano-bundler` (2.1) - Bundler integration
- `capistrano-rails` (1.7) - Rails application deployment
- `capistrano-rvm` (0.1.2) - RVM integration
- `capistrano-sidekiq` (3.0) - Sidekiq background job management
- `capistrano3-puma` (7.0) - Puma web server management
- `whenever` (1.1) - Cron job management
- `rollbar` (3.6) - Error tracking
- `ed25519` (1.3) and `bcrypt_pbkdf` (1.1) - SSH key support

## Quick Start

### Using Docker Hub

```bash
docker pull 7a6163/capistrano:latest
```

### Using GitHub Container Registry

```bash
docker pull ghcr.io/7a6163/capistrano:latest
```

### Basic Usage

1. Start the container and mount your project directory:

```bash
docker run -it --rm \
  -v $(pwd):/app \
  -v ~/.ssh:/root/.ssh:ro \
  7a6163/capistrano:latest
```

2. Run Capistrano deployment inside the container:

```bash
# Add SSH key (if needed)
ssh-add /root/.ssh/id_rsa

# Execute deployment
bundle exec cap production deploy
```

### One-line Deployment

Execute deployment command directly without entering the container:

```bash
docker run --rm \
  -v $(pwd):/app \
  -v ~/.ssh:/root/.ssh:ro \
  7a6163/capistrano:latest \
  bash -c "ssh-add /root/.ssh/id_rsa && bundle exec cap production deploy"
```

## Building the Project

### Local Build

```bash
docker build -t capistrano .
```

### Multi-platform Build

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t capistrano:latest \
  .
```

## CI/CD

The project uses GitHub Actions to automatically build and push Docker images:

- Triggered on pushes to the `main` branch
- Builds specific versions on tag pushes (v*)
- Pushes to both Docker Hub and GitHub Container Registry
- Supports amd64 and arm64 architectures

## Requirements

- Docker or Docker Desktop
- SSH keys (for connecting to remote servers)
- Capistrano configuration files (config/deploy.rb, etc.)

## Important Notes

- The container disables SSH host key checking by default (StrictHostKeyChecking no)
- SSH keys should be mounted in read-only mode for security
- entrypoint.sh automatically starts the SSH Agent

## Directory Structure

```
.
├── Dockerfile          # Docker image definition
├── entrypoint.sh       # Container startup script
├── Gemfile            # Ruby dependencies
├── Gemfile.lock       # Locked dependency versions
└── .github/
    └── workflows/
        └── docker-publish.yml  # CI/CD workflow
```

## License

This project is open source and contributions are welcome.

## Links

- [Capistrano Documentation](https://capistranorb.com/)
- [Docker Hub](https://hub.docker.com/r/7a6163/capistrano)
- [GitHub Repository](https://github.com/7a6163/capistrano-deploy)
