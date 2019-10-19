# madlambda.io

madlambda.io rules:

- Every global change in the servers must be automated in this repository.
- Just the madlambda owners have root access to the servers.
- Users should use their own home directory to store personal stuff.

# installation

Clone this repo inside /root and run:

```
# ./install.sh
# systemctl start unit
# ./unit/apply.sh
```

