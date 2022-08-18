# CheckMySum

Script to easily compare checksums of files on Linux and MacOS. 
It can compare checksums for these algorithms :
- md5
- sha1
- sha256
- sha512

## Usage

1. Download script & give it proper autorizations.
2. Lauch script.
3. Enter hash given by third party when prompt.
4. That's it !

## Syntax

```console
$ ./checkmysum <algorithm> <path_to_file>
```

For instance :

```console
$ ./checkmysum sha256 ~/Downloads/App.rpm
```

When prompt :

```txt
Please insert reference hash for comparison : 60b2c09ec10c513a5ffcecdca24c94b8e5afe80b
```

```txt
OK ! Checksums are a match :-)
```
