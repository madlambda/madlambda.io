# Authentication service

Before any inferno machine can access resources on inferno servers it needs
to obtain a valid certificate from a signer (or auth service).

Madlambda.io has a signer running at auth.madlambda.io and here is the 
script to build and configure this signer.

## Building

To build the docker image just type:

```
% mk image
```

## Starting

The first time you run the auth service you'll need to answer some 
security questions (like the passphrase of the keyfs).

Execute:

```
% docker run -it madlambda/inferno-auth:0.1
Configuring signer.
!!! You are about to reset the auth keys file.
Press ENTER to continue or CTRL-C to abort


Generating certificates for  madlambda.io ...
Key: 
Confirm key: 
services running:
       1        1       root    0:00.0    release   148K Sh[$Sys]
      16       15       root    0:00.0        alt    17K Cs
      20       19       root    0:00.0       recv    25K Keyfs
      21       19       root    0:00.0    release    46K Styx[$Sys]
      22       19       root    0:00.0       recv    25K Keyfs
      24        1       root    0:00.0        alt     9K Listen
      26        1       root    0:00.0    release     9K Listen[$Sys]
      28        1       root    0:00.0        alt     9K Listen
      30        1       root    0:00.0    release     9K Listen[$Sys]
      32        1       root    0:00.0        alt     9K Listen
      34        1       root    0:00.0    release     9K Listen[$Sys]
      36        1       root    0:00.0        alt     9K Listen
      38        1       root    0:00.0    release     9K Listen[$Sys]
      40        1       root    0:00.0      ready    74K Ps[$Sys]
Press any key to stop the auth service
```
It shows the processes running, just make sure Keyfs is running.

## Customizations

The image has the following environment variables:

- DOMAIN: Set to the domain of your site/cluster
- TZ: Timezone of the server
- WINRES: Graphical window resolution

If you change the DOMAIN, then make sure to update the field 
dnsdomain of the file /lib/ndb/local also.

That's all folks!