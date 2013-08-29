## omputercraft Scripts
=============

My scripts for computercraft.

The scripts which are intended to be installed on Computercraft-Computers in Minecraft are hosted on Github.


### Computercraft Package Manager
#### Repository
Can run on any hardware that can run nodejs (and redis)
[CPM-Repository](https://github.com/Tyderion/cpm-repository)


#### CPM 
Installs and updates programs via the Repository.
[CPM](https://gist.github.com/Tyderion/6296195)

### Resource Order/Management System

A simple master-slave + client system to order resources in Minecraft.

#### Master
The master connects to the slaves and to the order/client programs. Keeps a list of available resources which the slaves register on startup.
[Master](https://gist.github.com/Tyderion/6298100)

#### Slave
Registers configured resources (front, back, right) with the master and puts about 60 (when using an electrical engine with geothermal generator as power source at least) of the items from the barrel into the pipe leading to an ender chest.

[Slave](https://gist.github.com/Tyderion/6298113)


#### Order
Graphical Ordering GUI. There is a search-as-you-type functionality for all resources registered with the master. The master sends the list as a JSON to the order program.
[Master](https://gist.github.com/Tyderion/6298100)
