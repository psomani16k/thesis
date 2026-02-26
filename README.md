# Setting up the Simulation Environment

> [!note]
> This guide assumes you have Docker setup and can run the docker compose command!

1. Clone this repo in your preferred directory (this guide assumes the home directory, so `~/thesis`)
    - [**OPTIONAL**] Since we are going to use the container's shell, you can move your preferred shell binaries like zellij/fish etc. to the `thesis/bins` directory which exposes these bins on PATH in the container. Additionally you can also move the respective content of your `.config/` directory to `~/thesis/config` which will expose your configs in the container. This is not necessary, just to help improve your workflow. The rest of the guide assumes you do NOT do this step.

2. Go to the `thesis/env` directory and run `docker compose up -d`. If you have cloned this repo in the home directory, then just use these commands:
```bash
cd ~/thesis/env
docker compose up -d
```

3. Now we will access the shell inside the container.
```bash
docker exec -it mptcp_simulation bash
```

4. Go to the `/workspace` directory and run the `setup.sh` script
```bash
cd /workspace
./setup.sh
```

5. The script will setup the environment to run the simulations. After completion the simulation can be run by:
```bash
cd /workspace/bake/sources/ns-3-dce
./waf --run mptcp
```

# Editing the Files and Running Simulations
The setup is such that all the files of the simulator are accessible in the `~/thesis/data/bake` directory (or `{wherever you cloned this repo}/data/bake`). 
This means the files can be edited inside this directory using your preferred editor of choice.

Simulations have to be run via the above setup Docker container. So you need to run:
```bash
docker exec -it mptcp_simulation bash
cd /workspace/bake/sources/ns-3-dce
./waf --run mptcp # or which ever project you need to run
```

## Modify the Simulation Kernel
If you want to change the behavior of the Kernel or the MPTCP stack. You can find them in the `~/thesis/data/bake/source/net-next-nuse-mptcp` directory.

> [!note]
> Any changes made in the kernel (net-next-nuse-mptcp) will only reflect on a complete project rebuild. Below are the steps

### Rebuilding the Project
1. Access the container shell:
```bash
docker exec -it mptcp_simulation bash
```

2. Go to the project root directory:
```bash
cd /workspace/bake
```

3. Build the project:
```bash
./bake.py build # add -v or -vvv if you want verbose or very very verbose logging respectively (note -vv is not an option)
```
