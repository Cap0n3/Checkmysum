# CheckMySum

Script to easily verify file checksum on Linux and MacOS terminal. 

It generates a hash with given file for these algorithms :
- md5
- sha1
- sha256
- sha512

And then automatically compare generated hash with given third-party hash and output result.

## Usage

1. Download script & give it proper autorizations.
2. Lauch script.
3. Enter hash given by third-party when prompt.
4. That's it !

## Syntax

```console
$ ./checkmysum <algorithm> <path_to_file>
```
> **Note :** simply replace `<algorithm>` with `md5`, `sha1`, `sha256` or `sha512`

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
