# Notes

## Virtualization

### Basic definition

- Virtualization - process of creating a virtual machine
- Virtual machine - efficient isolated duplicate of a real machine
- Guest OS - runs in a VM
- Host OS - runs on a host
- Hypervisor (virtual machine monitor) - software that implements the VM

### History

- (1960-1970) - IBM mainframes
- (1980s) - weak commercial interest (cheaper, smaller HW, multitasking OS)
- (1998-1999) - VMware
- (2003) - first open source hypervisor (Xen)
- (2006) - hardware supported virtualizaion enhanced with Intel VT-x & AMD-V
- (2007) - Linux KVM

### Taxonomy

- execution environment
  - process level
    - emulation (application)
    - high-level VM (programming language)
    - multiprogramming (operation system)
  - system level
    - hardware assisted virtualization
    - full virtualization
    - paravirtualization
    - partial virtualization
- storage
- network
- ...

### Architecture and interfaces

- API (application programming interface)
- ABI (application binary interface)
- Systen ISA, User ISA (instruction set architecture)

### Types of virtualization

- process virtualization (.NET, Java, different ISA)
- OS level virtualization (containers)
- device virtualization (logical, physical)
- system/platform virtualization (hypervisors)
- server virtualization
- desktop virtualization
- application virtualization (isolation, streaming)

### Classic virtualization

- equivalence/fidelity - run any software in a VM can't tell the difference
- efficiency/performance - run it fairly fast, non sensitive instructions should execute directly on the hardware
- resource control/isolation/safety - VMM manages all hardware, isolates VMs between themselves
- trap and emulate
  - not all privileged instructions produce traps on x86
  - trap CPU overhead is high
  - many traps are unavoidable (page faults)
  - possible solutions:
    - rewrite problem instructions (binary translation)
    - change guest OS (paravirtualization)
    - change hardware architecture

### What to virtualize

- CPU
- memory
- I/O devices
- network

### Virtualization before vs after

- before
  - single OS per machine
  - software/hardware tightly coupled
  - conflicts when running multiple applications on same machine
  - underutilized resources
  - inflexible and costly infrastructure
- after
  - hardware independence of OS and applications
  - VMs can be provisioned to any system
  - OS and applications can be managed by encapsulating them into VMs

### Hypervisor types

- type 1
  - native / bare metal hypervisors
  - higher performance
  - ESXi, HyperV, Xen
  - runs directly on hardware
- type 2
  - hosted hypervisors
  - slower performance
  - can reuse OS services
  - VirtualBox, VMware
  - runs on host OS

### Virtualization types

- full virtualization
  - VM -> emulated hardware -> host OS -> hardware
  - binary dynamic translation (intercept privileged instructions by changing the binary)
  - software based
  - unmodified guest
  - all hardware is emulated, including CPU
  - QEMU
- paravirtualization
  - VM -> VMM -> hypervisor -> hardware
  - modifying OS kernel
    - OS needs to be aware of virtualization
    - paravirtualization drivers and API must be in guest OS kernel
  - installing paravirtualized drivers
    - paravirtualization can be enabled for individual devices
    - some OS don't have fully paravirtualized kernel
- hardware assisted virtualization
  - VM -> VMM -> hypervisor -> hardware
  - VMM runs in virtual ring -1
  - guest OS runs in ring 0
  - needs special HW CPU extensions (Intel VT/AMD-V)