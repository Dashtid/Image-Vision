# Image Vision Algorithms - Claude Code Guidelines

## Project Overview

This project demonstrates core image processing and computer vision algorithms in MATLAB, including frequency domain filtering, edge detection, Hough transform, and several image segmentation techniques. The code is organized as self-contained scripts for educational and experimental use, covering fundamental concepts in digital image processing.

## Development Environment

**Operating System**: Windows 11
**Shell**: Git Bash / PowerShell / Command Prompt
**Important**: Always use Windows-compatible commands:
- Use `dir` instead of `ls` for Command Prompt
- Use PowerShell commands when appropriate
- File paths use backslashes (`\`) in Windows
- Use `python -m http.server` for local development server
- Git Bash provides Unix-like commands but context should be Windows-aware

## Development Guidelines

### Code Quality
- Follow MATLAB coding conventions and best practices
- Use meaningful variable and function names
- Implement proper error handling for image processing operations
- Add comprehensive comments explaining algorithm steps
- Use consistent indentation and formatting
- Maintain clean, readable code
- Follow language-specific best practices

### Security
- No sensitive information in the codebase
- Use HTTPS for all external resources
- Regular dependency updates
- Follow security best practices for the specific technology stack

### MATLAB-Specific Guidelines
- Use vectorized operations where possible for performance
- Implement proper memory management for large images
- Use appropriate MATLAB toolboxes (Image Processing, Computer Vision)
- Follow MATLAB naming conventions (camelCase for functions, lowercase for variables)
- Use built-in MATLAB functions when available rather than custom implementations
- Implement proper figure and plot management to avoid memory leaks

## Learning and Communication
- Always explain coding actions and decisions to help the user learn
- Describe why specific approaches or technologies are chosen
- Explain the purpose and functionality of code changes
- Provide context about best practices and coding patterns used
- Provide detailed explanations in the console when performing tasks, as many concepts may be new to the user