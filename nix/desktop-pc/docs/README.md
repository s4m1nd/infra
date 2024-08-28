The XML file for VM will need a couple values to be modified to look more like a real device. Additionally the XML may not work as-is on different systems and additional tweaks will be required for different hardware configuration.
Installation will require a couple steps to be made before successfully allowing GPU passthrough such as installing virtIO drivers, looking-glass-host, NVIDIA drivers, USB passthrough, etc.

```sh
# requires dmidecode
./patch-xml-domain.sh
```

requires virtio iso, looking-glass-host-b6 for windows host and win10 ISO.
