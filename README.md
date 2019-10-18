# PAC_CALC

Signed add/sub package(VHDL)

- sign-magnitude
- Variable length

## Data type

**argument**

bit length:L

| Bit     | Type               |
| ------- | ------------------ |
| [L-1]   | sign               |
| [L-2:0] | fixed point number |

**return**

bit length:L+1

| Bit     | Type               |
| ------- | ------------------ |
| [L]     | sign               |
| [L-1]   | carry bit          |
| [L-2:0] | fixed point number |

## License

MIT License

## Author

[toms74209200](<https://github.com/toms74209200>)