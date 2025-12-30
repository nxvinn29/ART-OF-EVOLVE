# Security Policy

## Supported Versions

We currently support the latest major version of the application. Please ensure all dependencies are up to date to avoid known vulnerabilities.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it via email to nxvinn29@gmail.com.

### What to Include
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Suggested fix (if any)

### Response Time
We will try to review and address the issue as soon as possible, typically within:
- **Critical vulnerabilities**: 24-48 hours
- **High severity**: 3-7 days
- **Medium/Low severity**: 1-2 weeks

## Security Best Practices

### For Users
- Keep the app updated to the latest version
- Use strong authentication credentials
- Be cautious about granting permissions
- Report suspicious behavior immediately

### For Contributors
- Never commit sensitive data (API keys, passwords, etc.)
- Use environment variables for configuration
- Follow secure coding practices
- Run security scans before submitting PRs
- Keep dependencies up to date

## Data Privacy

This app stores data locally using Hive. We do not collect or transmit personal data to external servers. All user data remains on the device.

### Local Data Storage
- Habits and journal entries are stored locally
- No cloud synchronization by default
- Data is not encrypted at rest (consider device-level encryption)

## Known Security Considerations

- **Local Storage**: Data is stored in plain text in Hive boxes
- **No Authentication**: App does not require login (single-user device)
- **Permissions**: App may request storage and notification permissions

## Security Updates

Security updates will be released as patch versions (e.g., 1.0.1, 1.0.2) and documented in the CHANGELOG.

