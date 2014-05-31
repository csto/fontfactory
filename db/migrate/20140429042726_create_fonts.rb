class CreateFonts < ActiveRecord::Migration
  def change
    create_table :fonts do |t|
      t.string :name, default: 'New Font'
      t.integer :grid, default: 100
      t.integer :x_height, default: 400
      t.integer :overshoot, default: 10
      t.integer :ascent_height, default: 700
      t.integer :line_gap, default: 250
      t.text :characters, default: characters

      t.timestamps
    end
  end
  
  def characters
    [
      {unicode: '0x20', character: ' ', decimal:  '&#32;', name:	'Space'},
      {unicode: '0x21', character: '!', decimal:  '&#33;', name:	'Exclamation mark	'},
      {unicode: '0x22', character: '"', decimal:  '&#34;', name:	'Quotation mark	'},
      {unicode: '0x23', character: '#', decimal:  '&#35;', name:	'Number sign, Hash tag	'},
      {unicode: '0x24', character: '$', decimal:  '&#36;', name:	'Dollar sign	'},
      {unicode: '0x25', character: '%', decimal:  '&#37;', name:	'Percent sign	'},
      {unicode: '0x26', character: '&', decimal:  '&#38;', name:	'Ampersand	'},
      {unicode: '0x27', character: '\'', decimal:  '&#39;', name:	'Apostrophe	'},
      {unicode: '0x28', character: '(', decimal:  '&#40;', name:	'Left parenthesis	'},
      {unicode: '0x29', character: ')', decimal:  '&#41;', name:	'Right parenthesis	'},
      {unicode: '0x2A', character: '*', decimal:  '&#42;', name:	'Asterisk	'},
      {unicode: '0x2B', character: '+', decimal:  '&#43;', name:	'Plus sign	'},
      {unicode: '0x2C', character: ',', decimal:  '&#44;', name:	'Comma	'},
      {unicode: '0x2D', character: '-', decimal:  '&#45;', name:	'Hyphen-minus	'},
      {unicode: '0x2E', character: '.', decimal:  '&#46;', name:	'Full stop	'},
      {unicode: '0x2F', character: '/', decimal:  '&#47;', name:	'Slash (Solidus)	'},
      {unicode: '0x30', character: '0', decimal:  '&#48;', name:	'Digit Zero	'},
      {unicode: '0x31', character: '1', decimal:  '&#49;', name:	'Digit One	'},
      {unicode: '0x32', character: '2', decimal:  '&#50;', name:	'Digit Two	'},
      {unicode: '0x33', character: '3', decimal:  '&#51;', name:	'Digit Three	'},
      {unicode: '0x34', character: '4', decimal:  '&#52;', name:	'Digit Four	'},
      {unicode: '0x35', character: '5', decimal:  '&#53;', name:	'Digit Five	'},
      {unicode: '0x36', character: '6', decimal:  '&#54;', name:	'Digit Six	'},
      {unicode: '0x37', character: '7', decimal:  '&#55;', name:	'Digit Seven	'},
      {unicode: '0x38', character: '8', decimal:  '&#56;', name:	'Digit Eight	'},
      {unicode: '0x39', character: '9', decimal:  '&#57;', name:	'Digit Nine	'},
      {unicode: '0x3A', character: ':', decimal:  '&#58;', name:	'Colon	'},
      {unicode: '0x3B', character: ';', decimal:  '&#59;', name:	'Semicolon	'},
      {unicode: '0x3C', character: '<', decimal:  '&#60;', name:	'Less-than sign	'},
      {unicode: '0x3D', character: '=', decimal:  '&#61;', name:	'Equal sign	'},
      {unicode: '0x3E', character: '>', decimal:  '&#62;', name:	'Greater-than sign	'},
      {unicode: '0x3F', character: '?', decimal:  '&#63;', name:	'Question mark	'},
      {unicode: '0x40', character: '@', decimal:  '&#64;', name:	'At sign	'},
      {unicode: '0x41', character: 'A', decimal:  '&#65;', name:	'Latin Capital letter A	'},
      {unicode: '0x42', character: 'B', decimal:  '&#66;', name:	'Latin Capital letter B	'},
      {unicode: '0x43', character: 'C', decimal:  '&#67;', name:	'Latin Capital letter C	'},
      {unicode: '0x44', character: 'D', decimal:  '&#68;', name:	'Latin Capital letter D	'},
      {unicode: '0x45', character: 'E', decimal:  '&#69;', name:	'Latin Capital letter E	'},
      {unicode: '0x46', character: 'F', decimal:  '&#70;', name:	'Latin Capital letter F	'},
      {unicode: '0x47', character: 'G', decimal:  '&#71;', name:	'Latin Capital letter G	'},
      {unicode: '0x48', character: 'H', decimal:  '&#72;', name:	'Latin Capital letter H	'},
      {unicode: '0x49', character: 'I', decimal:  '&#73;', name:	'Latin Capital letter I	'},
      {unicode: '0x4A', character: 'J', decimal:  '&#74;', name:	'Latin Capital letter J	'},
      {unicode: '0x4B', character: 'K', decimal:  '&#75;', name:	'Latin Capital letter K	'},
      {unicode: '0x4C', character: 'L', decimal:  '&#76;', name:	'Latin Capital letter L	'},
      {unicode: '0x4D', character: 'M', decimal:  '&#77;', name:	'Latin Capital letter M	'},
      {unicode: '0x4E', character: 'N', decimal:  '&#78;', name:	'Latin Capital letter N	'},
      {unicode: '0x4F', character: 'O', decimal:  '&#79;', name:	'Latin Capital letter O	'},
      {unicode: '0x50', character: 'P', decimal:  '&#80;', name:	'Latin Capital letter P	'},
      {unicode: '0x51', character: 'Q', decimal:  '&#81;', name:	'Latin Capital letter Q	'},
      {unicode: '0x52', character: 'R', decimal:  '&#82;', name:	'Latin Capital letter R	'},
      {unicode: '0x53', character: 'S', decimal:  '&#83;', name:	'Latin Capital letter S	'},
      {unicode: '0x54', character: 'T', decimal:  '&#84;', name:	'Latin Capital letter T	'},
      {unicode: '0x55', character: 'U', decimal:  '&#85;', name:	'Latin Capital letter U	'},
      {unicode: '0x56', character: 'V', decimal:  '&#86;', name:	'Latin Capital letter V	'},
      {unicode: '0x57', character: 'W', decimal:  '&#87;', name:	'Latin Capital letter W	'},
      {unicode: '0x58', character: 'X', decimal:  '&#88;', name:	'Latin Capital letter X	'},
      {unicode: '0x59', character: 'Y', decimal:  '&#89;', name:	'Latin Capital letter Y	'},
      {unicode: '0x5A', character: 'Z', decimal:  '&#90;', name:	'Latin Capital letter Z	'},
      {unicode: '0x5B', character: '[', decimal:  '&#91;', name:	'Left Square Bracket	'},
      {unicode: '0x5C', character: '\\', decimal:  '&#92;', name:	'Backslash	'},
      {unicode: '0x5D', character: ']', decimal:  '&#93;', name:	'Right Square Bracket	'},
      {unicode: '0x5E', character: '^', decimal:  '&#94;', name:	'Circumflex accent	'},
      {unicode: '0x5F', character: '_', decimal:  '&#95;', name:	'Low line	'},
      {unicode: '0x60', character: '`', decimal:  '&#96;', name:	'Grave accent	'},
      {unicode: '0x61', character: 'a', decimal:  '&#97;', name:	'Latin Small Letter A	'},
      {unicode: '0x62', character: 'b', decimal:  '&#98;', name:	'Latin Small Letter B	'},
      {unicode: '0x63', character: 'c', decimal:  '&#99;', name:	'Latin Small Letter C	'},
      {unicode: '0x64', character: 'd', decimal: '&#100;', name:	'Latin Small Letter D	'},
      {unicode: '0x65', character: 'e', decimal: '&#101;', name:	'Latin Small Letter E	'},
      {unicode: '0x66', character: 'f', decimal: '&#102;', name:	'Latin Small Letter F	'},
      {unicode: '0x67', character: 'g', decimal: '&#103;', name:	'Latin Small Letter G	'},
      {unicode: '0x68', character: 'h', decimal: '&#104;', name:	'Latin Small Letter H	'},
      {unicode: '0x69', character: 'i', decimal: '&#105;', name:	'Latin Small Letter I	'},
      {unicode: '0x6A', character: 'j', decimal: '&#106;', name:	'Latin Small Letter J	'},
      {unicode: '0x6B', character: 'k', decimal: '&#107;', name:	'Latin Small Letter K	'},
      {unicode: '0x6C', character: 'l', decimal: '&#108;', name:	'Latin Small Letter L	'},
      {unicode: '0x6D', character: 'm', decimal: '&#109;', name:	'Latin Small Letter M	'},
      {unicode: '0x6E', character: 'n', decimal: '&#110;', name:	'Latin Small Letter N	'},
      {unicode: '0x6F', character: 'o', decimal: '&#111;', name:	'Latin Small Letter O	'},
      {unicode: '0x70', character: 'p', decimal: '&#112;', name:	'Latin Small Letter P	'},
      {unicode: '0x71', character: 'q', decimal: '&#113;', name:	'Latin Small Letter Q	'},
      {unicode: '0x72', character: 'r', decimal: '&#114;', name:	'Latin Small Letter R	'},
      {unicode: '0x73', character: 's', decimal: '&#115;', name:	'Latin Small Letter S	'},
      {unicode: '0x74', character: 't', decimal: '&#116;', name:	'Latin Small Letter T	'},
      {unicode: '0x75', character: 'u', decimal: '&#117;', name:	'Latin Small Letter U	'},
      {unicode: '0x76', character: 'v', decimal: '&#118;', name:	'Latin Small Letter V	'},
      {unicode: '0x77', character: 'w', decimal: '&#119;', name:	'Latin Small Letter W	'},
      {unicode: '0x78', character: 'x', decimal: '&#120;', name:	'Latin Small Letter X	'},
      {unicode: '0x79', character: 'y', decimal: '&#121;', name:	'Latin Small Letter Y	'},
      {unicode: '0x7A', character: 'z', decimal: '&#122;', name:	'Latin Small Letter Z	'},
      {unicode: '0x7B', character: '{', decimal: '&#123;', name:	'Left Curly Bracket	'},
      {unicode: '0x7C', character: '|', decimal: '&#124;', name:	'Vertical bar	'},
      {unicode: '0x7D', character: '}', decimal: '&#125;', name:	'Right Curly Bracket	'},
      {unicode: '0x7E', character: '~', decimal: '&#126;', name:	'Tilde	'},
      {unicode: '0x7F', character: '', decimal: '&#127;', name:	'Delete'}
    ].to_json
  end
end
