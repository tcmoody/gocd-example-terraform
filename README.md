# gocd-example-terraform
Sample terraform for spinning up a GoCD server + agent combo

Just add a profile in the variables.tfvars in the root folder, replace the provision key (also located in the variables.tfvars) and you're ready to go!

Also, the hosted_zones terraform is not currently working, so to get to the gocd-server ui you'll need to hit the load balancer A record directly.
