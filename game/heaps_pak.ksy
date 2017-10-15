meta:
  id: heaps_pak
  file-extension: pak
  application: Games based on Haxe Game Framework "Heaps" (e.g. Dead Cells)
  endian: le
  license: MIT
  encoding: UTF-8
doc-ref: 'https://github.com/HeapsIO/heaps/blob/2bbc2b386952dfd8856c04a854bb706a52cb4b58/hxd/fmt/pak/Reader.hx'
seq:
  - id: header
    type: header
types:
  header:
    seq:
      - id: magic1
        contents: 'PAK'
      - id: version
        type: u1
      - id: header_size
        type: u4
      - id: data_size
        type: u4
      - id: root_entry
        type: entry
        size: header_size - 16
      - id: magic2
        contents: 'DATA'
    types:
      entry:
        doc-ref: 'https://github.com/HeapsIO/heaps/blob/2bbc2b386952dfd8856c04a854bb706a52cb4b58/hxd/fmt/pak/Data.hx'
        seq:
          - id: name_len
            type: u1
          - id: name
            type: str
            size: name_len
          - id: flags
            type: flags
          - id: body
            type:
              switch-on: flags.is_dir
              cases:
                true : dir
                false : file
        types:
          flags:
            seq:
              - id: unused
                type: b7
              - id: is_dir
                type: b1
      file:
        seq:
          - id: data_pos
            type: u4
          - id: data_size
            type: u4
          # Adler32 checksum
          - id: checksum
            size: 4
        instances:
          data:
            io: _root._io
            pos: _root.header.header_size + data_pos
            size: data_size
      dir:
        seq:
          - id: num_entries
            type: u4
          - id: content
            type: entry
            repeat: expr
            repeat-expr: num_entries
