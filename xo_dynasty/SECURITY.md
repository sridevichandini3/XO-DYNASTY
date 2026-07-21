# Security Policy

## Current scope

This version of XO Dynasty is a fully offline, on-device game. It has
no backend, no network calls, and stores only a locally-generated
guest id and display name via `shared_preferences` on the player's own
device. There is no server-side attack surface to report against yet.

## Reporting a vulnerability

If you find a security issue (e.g. a way to corrupt local save data or
crash the app via malformed input), please open a private security
advisory on GitHub rather than a public issue, and include:

- Steps to reproduce
- Affected version
- Impact assessment

## Future scope

Once online multiplayer, authentication, or purchases are added, this
policy will be expanded to cover server-side reporting, and any
relevant bug bounty details will be listed here.
