# Swarm TCP proxy

This is a Docker image which is designed to act as a TCP load balancer service for another backend swarm service.

It supports the [Proxy Protocol](https://www.haproxy.com/blog/haproxy/proxy-protocol/) for passing through information about the original connection.

## What's the problem?

Every service running on a Docker swarm cluster has its own virtual IP address. The service containers are getting IP addresses from an overlay network with private IP addresses.

As [every connection is routed through an ingress network](https://github.com/moby/moby/issues/25526), a service container will see an address from the ingress network for each incoming connection. It is thus unable to find out the real remote address.

As a workaround, the service can publish a port [directly on the host](https://github.com/moby/moby/issues/25526#issuecomment-336363408). As this is only effective on the host the container is running on, the service has thus to be made [global](https://github.com/moby/moby/issues/25526#issuecomment-275292393) so it will be started on every host in the cluster.

For cases where this is not a feasible solution, Swarm TCP proxy comes into play.

## How does it work?

Swarm TCP proxy is deployed as a global service, i.e. on all nodes in the cluster. As each instance is just a [HAProxy](https://www.haproxy.com/) instance, this has quite a small footprint.

It will forward each incoming connection to the virtual IP of the real service, which is then routed to the final container by Docker swarm itself.

In order to for the container to see the original remote address, Swarm TCP proxy uses the [Proxy Protocol](https://www.haproxy.com/).

This means that the deployed application has to support the Proxy Protocol as well. See [this introductory post](https://www.haproxy.com/blog/haproxy/proxy-protocol/) for which software already supports the protocol.

## Usage

See the supplied [docker-compose.yml](docker-compose.yml) for an example. It uses the sample [proxy-responder service](https://github.com/djmaze/proxy-responder) which just returns the remote IP and closes the connection.

Example output:

    $ docker-compose up -d
    $ telnet localhost 8000
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Hello, 192.168.80.1:37174
    Connection closed by foreign host.

The proxy itself runs on port 8000.

It is configured through ENV variables which are mandatory:

* `SERVICE_NAME`: name of the connected Swarm service
* `SERVICE_PORT`: port on the service which should be proxied
