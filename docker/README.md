# Dockerized inferno

This script builds docker images of inferno.

## Building

The source of inferno is not distributed here, then you need to provide 
the location of the downloaded/cloned inferno source in the ROOT variable.

The script requires _mk_ to be installed in your PATH. If you don't have it, 
then you should install [plan9port](https://github.com/9fans/plan9port)
or just use the built versions of _mk_ distributed with inferno (but they 
are missing for some architectures). Inferno comes with mk binaries for 
several operating systems but few architectures (386 is the most available).

For example, if you downloaded inferno into /usr/inferno, then just run:

`````
% export PATH=$PATH:/usr/inferno/Linux/386/bin
% mk ROOT=/usr/inferno
```

If built sucessfully, you can push the image to registry:

```
% mk push
```

## Running

Emu is the image entrypoint, then just starting the container you will
end up in the inferno shell.

```sh
% docker run -it madlambda/inferno-linux-x86:0.1
; 
```

Now you can look at the [inferno install documentation](http://doc.cat-v.org/inferno/4th_edition/release_notes/install) to configure it as a server, signer or terminal.
