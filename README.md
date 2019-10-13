# PAC_CALC

Signed add/sub package(VHDL)

- sign*-*magnitude
- Variable length

## Data type

**argument**

| Bit       | Type               |
| --------- | ------------------ |
| [MSB]     | sign               |
| [MSB-1:0] | fixed point number |

**return**

| Bit       | Type               |
| --------- | ------------------ |
| [MSB]     | sign               |
| [MSB-1]   | carry bit          |
| [MSB-2:0] | fixed point number |

## License

MIT License

## Author

[toms74209200](<https://github.com/toms74209200>)