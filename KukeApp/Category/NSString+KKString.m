//
//  NSString+KKString.m
//  kuke
//
//  Created by iOSDeveloper on 2017/10/28.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (KKString)

- (NSString *)replaceSpecialCharacter {
    NSString *string = self;
    
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    string = [string stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    string = [string stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    string = [string stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    string = [string stringByReplacingOccurrencesOfString:@"&yen;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    string = [string stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    string = [string stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    string = [string stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    string = [string stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    string = [string stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    string = [string stringByReplacingOccurrencesOfString:@"&shy;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    string = [string stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    string = [string stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    string = [string stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    string = [string stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    string = [string stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    string = [string stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aacute;" withString:@"Á"];
    string = [string stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    string = [string stringByReplacingOccurrencesOfString:@"&Atilde;" withString:@"Ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&Auml;" withString:@"Ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    string = [string stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eacute;" withString:@"É"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ecirc;" withString:@"Ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&Euml;" withString:@"Ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iacute;" withString:@"Í"];
    string = [string stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iuml;" withString:@"Ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oacute;" withString:@"Ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ocirc;" withString:@"Ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&Otilde;" withString:@"Õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ouml;" withString:@"Ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uacute;" withString:@"Ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ucirc;" withString:@"Û"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uuml;" withString:@"Ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yacute;" withString:@"Ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string = [string stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    string = [string stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&aring;" withString:@"å"];
    string = [string stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&ecirc;" withString:@"ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&euml;" withString:@"ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string = [string stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    string = [string stringByReplacingOccurrencesOfString:@"&iuml;" withString:@"ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&ocirc;" withString:@"ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&otilde;" withString:@"õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    string = [string stringByReplacingOccurrencesOfString:@"&oslash;" withString:@"ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&ucirc;" withString:@"û"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&yacute;" withString:@"ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&yuml;" withString:@"ÿ"];
    string = [string stringByReplacingOccurrencesOfString:@"&fnof;" withString:@"ƒ"];
    string = [string stringByReplacingOccurrencesOfString:@"&larr;" withString:@"←"];
    string = [string stringByReplacingOccurrencesOfString:@"&uarr;" withString:@"↑"];
    string = [string stringByReplacingOccurrencesOfString:@"&rarr;" withString:@"→"];
    string = [string stringByReplacingOccurrencesOfString:@"&darr;" withString:@"↓"];
    string = [string stringByReplacingOccurrencesOfString:@"&harr;" withString:@"↔"];
    string = [string stringByReplacingOccurrencesOfString:@"&crarr;" withString:@"↵"];
    string = [string stringByReplacingOccurrencesOfString:@"&lArr;" withString:@"⇐"];
    string = [string stringByReplacingOccurrencesOfString:@"&uArr;" withString:@"⇑"];
    string = [string stringByReplacingOccurrencesOfString:@"&rArr;" withString:@"⇒"];
    string = [string stringByReplacingOccurrencesOfString:@"&dArr;" withString:@"⇓"];
    string = [string stringByReplacingOccurrencesOfString:@"&hArr;" withString:@"⇔"];
    string = [string stringByReplacingOccurrencesOfString:@"&forall;" withString:@"∀"];
    string = [string stringByReplacingOccurrencesOfString:@"&part;" withString:@"∂"];
    string = [string stringByReplacingOccurrencesOfString:@"&exist;" withString:@"∃"];
    string = [string stringByReplacingOccurrencesOfString:@"&empty;" withString:@"∅"];
    string = [string stringByReplacingOccurrencesOfString:@"&nabla;" withString:@"∇"];
    string = [string stringByReplacingOccurrencesOfString:@"&isin;" withString:@"∈"];
    string = [string stringByReplacingOccurrencesOfString:@"&notin;" withString:@"∉"];
    string = [string stringByReplacingOccurrencesOfString:@"&ni;" withString:@"∋"];
    string = [string stringByReplacingOccurrencesOfString:@"&prod;" withString:@"∏"];
    string = [string stringByReplacingOccurrencesOfString:@"&sum;" withString:@"∑"];
    string = [string stringByReplacingOccurrencesOfString:@"&minus;" withString:@"−"];
    string = [string stringByReplacingOccurrencesOfString:@"&lowast;" withString:@"∗"];
    string = [string stringByReplacingOccurrencesOfString:@"&radic;" withString:@"√"];
    string = [string stringByReplacingOccurrencesOfString:@"&prop;" withString:@"∝"];
    string = [string stringByReplacingOccurrencesOfString:@"&infin;" withString:@"∞"];
    string = [string stringByReplacingOccurrencesOfString:@"&ang;" withString:@"∠"];
    string = [string stringByReplacingOccurrencesOfString:@"&and;" withString:@"∧"];
    string = [string stringByReplacingOccurrencesOfString:@"&or;" withString:@"∨"];
    string = [string stringByReplacingOccurrencesOfString:@"&cap;" withString:@"∩"];
    string = [string stringByReplacingOccurrencesOfString:@"&cup;" withString:@"∪"];
    string = [string stringByReplacingOccurrencesOfString:@"&int;" withString:@"∫"];
    string = [string stringByReplacingOccurrencesOfString:@"&there4;" withString:@"∴"];
    string = [string stringByReplacingOccurrencesOfString:@"&sim;" withString:@"∼"];
    string = [string stringByReplacingOccurrencesOfString:@"&cong;" withString:@"≅"];
    string = [string stringByReplacingOccurrencesOfString:@"&asymp;" withString:@"≈"];
    string = [string stringByReplacingOccurrencesOfString:@"&ne;" withString:@"≠"];
    string = [string stringByReplacingOccurrencesOfString:@"&equiv;" withString:@"≡"];
    string = [string stringByReplacingOccurrencesOfString:@"&le;" withString:@"≤"];
    string = [string stringByReplacingOccurrencesOfString:@"&ge;" withString:@"≥"];
    string = [string stringByReplacingOccurrencesOfString:@"&sub;" withString:@"⊂"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup;" withString:@"⊃"];
    string = [string stringByReplacingOccurrencesOfString:@"&nsub;" withString:@"⊄"];
    string = [string stringByReplacingOccurrencesOfString:@"&sube;" withString:@"⊆"];
    string = [string stringByReplacingOccurrencesOfString:@"&supe;" withString:@"⊇"];
    string = [string stringByReplacingOccurrencesOfString:@"&oplus;" withString:@"⊕"];
    string = [string stringByReplacingOccurrencesOfString:@"&otimes;" withString:@"⊗"];
    string = [string stringByReplacingOccurrencesOfString:@"&perp;" withString:@"⊥"];
    string = [string stringByReplacingOccurrencesOfString:@"&sdot;" withString:@"⋅"];
    string = [string stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];
    string = [string stringByReplacingOccurrencesOfString:@"&prime;" withString:@"′"];
    string = [string stringByReplacingOccurrencesOfString:@"&Prime;" withString:@"″"];
    string = [string stringByReplacingOccurrencesOfString:@"&oline;" withString:@"‾"];
    string = [string stringByReplacingOccurrencesOfString:@"&frasl;" withString:@"⁄"];
    string = [string stringByReplacingOccurrencesOfString:@"&lceil;" withString:@"⌈"];
    string = [string stringByReplacingOccurrencesOfString:@"&rceil;" withString:@"⌉"];
    string = [string stringByReplacingOccurrencesOfString:@"&lfloor;" withString:@"⌊"];
    string = [string stringByReplacingOccurrencesOfString:@"&rfloor;" withString:@"⌋"];
    string = [string stringByReplacingOccurrencesOfString:@"&lang;" withString:@"⟨"];
    string = [string stringByReplacingOccurrencesOfString:@"&rang;" withString:@"⟩"];
    string = [string stringByReplacingOccurrencesOfString:@"&loz;" withString:@"◊"];
    string = [string stringByReplacingOccurrencesOfString:@"&spades;" withString:@"♠"];
    string = [string stringByReplacingOccurrencesOfString:@"&clubs;" withString:@"♣"];
    string = [string stringByReplacingOccurrencesOfString:@"&hearts;" withString:@"♥"];
    string = [string stringByReplacingOccurrencesOfString:@"&diams;" withString:@"♦"];
    string = [string stringByReplacingOccurrencesOfString:@"&weierp;" withString:@"℘"];
    string = [string stringByReplacingOccurrencesOfString:@"&image;" withString:@"ℑ"];
    string = [string stringByReplacingOccurrencesOfString:@"&real;" withString:@"ℜ"];
    string = [string stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
    string = [string stringByReplacingOccurrencesOfString:@"&alefsym;" withString:@"ℵ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Alpha;" withString:@"Α"];
    string = [string stringByReplacingOccurrencesOfString:@"&Beta;" withString:@"Β"];
    string = [string stringByReplacingOccurrencesOfString:@"&Gamma;" withString:@"Γ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Delta;" withString:@"Δ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Epsilon;" withString:@"Ε"];
    string = [string stringByReplacingOccurrencesOfString:@"&Zeta;" withString:@"Ζ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eta;" withString:@"Η"];
    string = [string stringByReplacingOccurrencesOfString:@"&Theta;" withString:@"Θ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iota;" withString:@"Ι"];
    string = [string stringByReplacingOccurrencesOfString:@"&Kappa;" withString:@"Κ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Lambda;" withString:@"Λ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Mu;" withString:@"Μ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Nu;" withString:@"Ν"];
    string = [string stringByReplacingOccurrencesOfString:@"&Xi;" withString:@"Ξ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Omicron;" withString:@"Ο"];
    string = [string stringByReplacingOccurrencesOfString:@"&Pi;" withString:@"Π"];
    string = [string stringByReplacingOccurrencesOfString:@"&Rho;" withString:@"Ρ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Sigma;" withString:@"Σ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Tau;" withString:@"Τ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Upsilon;" withString:@"Υ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Phi;" withString:@"Φ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Chi;" withString:@"Χ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Psi;" withString:@"Ψ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Omega;" withString:@"Ω"];
    string = [string stringByReplacingOccurrencesOfString:@"&alpha;" withString:@"α"];
    string = [string stringByReplacingOccurrencesOfString:@"&beta;" withString:@"β"];
    string = [string stringByReplacingOccurrencesOfString:@"&gamma;" withString:@"γ"];
    string = [string stringByReplacingOccurrencesOfString:@"&delta;" withString:@"δ"];
    string = [string stringByReplacingOccurrencesOfString:@"&epsilon;" withString:@"ε"];
    string = [string stringByReplacingOccurrencesOfString:@"&zeta;" withString:@"ζ"];
    string = [string stringByReplacingOccurrencesOfString:@"&eta;" withString:@"η"];
    string = [string stringByReplacingOccurrencesOfString:@"&theta;" withString:@"θ"];
    string = [string stringByReplacingOccurrencesOfString:@"&iota;" withString:@"ι"];
    string = [string stringByReplacingOccurrencesOfString:@"&kappa;" withString:@"κ"];
    string = [string stringByReplacingOccurrencesOfString:@"&lambda;" withString:@"λ"];
    string = [string stringByReplacingOccurrencesOfString:@"&mu;" withString:@"μ"];
    string = [string stringByReplacingOccurrencesOfString:@"&nu;" withString:@"ν"];
    string = [string stringByReplacingOccurrencesOfString:@"&xi;" withString:@"ξ"];
    string = [string stringByReplacingOccurrencesOfString:@"&omicron;" withString:@"ο"];
    string = [string stringByReplacingOccurrencesOfString:@"&pi;" withString:@"π"];
    string = [string stringByReplacingOccurrencesOfString:@"&rho;" withString:@"ρ"];
    string = [string stringByReplacingOccurrencesOfString:@"&sigmaf;" withString:@"ς"];
    string = [string stringByReplacingOccurrencesOfString:@"&sigma;" withString:@"σ"];
    string = [string stringByReplacingOccurrencesOfString:@"&tau;" withString:@"τ"];
    string = [string stringByReplacingOccurrencesOfString:@"&upsilon;" withString:@"υ"];
    string = [string stringByReplacingOccurrencesOfString:@"&phi;" withString:@"φ"];
    string = [string stringByReplacingOccurrencesOfString:@"&chi;" withString:@"χ"];
    string = [string stringByReplacingOccurrencesOfString:@"&psi;" withString:@"ψ"];
    string = [string stringByReplacingOccurrencesOfString:@"&omega;" withString:@"ω"];
    string = [string stringByReplacingOccurrencesOfString:@"&thetasym;" withString:@"ϑ"];
    string = [string stringByReplacingOccurrencesOfString:@"&upsih;" withString:@"ϒ"];
    string = [string stringByReplacingOccurrencesOfString:@"&piv;" withString:@"ϖ"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&OElig;" withString:@"Œ"];
    string = [string stringByReplacingOccurrencesOfString:@"&oelig;" withString:@"œ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Scaron;" withString:@"Š"];
    string = [string stringByReplacingOccurrencesOfString:@"&scaron;" withString:@"š"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yuml;" withString:@"Ÿ"];
    string = [string stringByReplacingOccurrencesOfString:@"&circ;" withString:@"ˆ"];
    string = [string stringByReplacingOccurrencesOfString:@"&tilde;" withString:@"˜"];
    string = [string stringByReplacingOccurrencesOfString:@"&ensp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&thinsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&zwnj;" withString:@" ‌"];
    string = [string stringByReplacingOccurrencesOfString:@"&zwj;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&lrm;" withString:@"‎ "];
    string = [string stringByReplacingOccurrencesOfString:@"&rlm;" withString:@" ‏"];
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
    string = [string stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    string = [string stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&sbquo;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    string = [string stringByReplacingOccurrencesOfString:@"&bdquo;" withString:@"„"];
    string = [string stringByReplacingOccurrencesOfString:@"&dagger;" withString:@"†"];
    string = [string stringByReplacingOccurrencesOfString:@"&Dagger;" withString:@"‡"];
    string = [string stringByReplacingOccurrencesOfString:@"&permil;" withString:@"‰"];
    string = [string stringByReplacingOccurrencesOfString:@"&lsaquo;" withString:@"‹"];
    string = [string stringByReplacingOccurrencesOfString:@"&rsaquo;" withString:@"›"];
    string = [string stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
    
    return string;
}

- (NSString *)stringByRemovingHTMLMark {
    NSString *string = [self replaceSpecialCharacter];
    
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString * HTMLmark = nil;
    
    while(![scanner isAtEnd]) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&HTMLmark];
        //替换字符
//        if (![HTMLmark hasPrefix:@"<img"]) {//不包含属性
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",HTMLmark] withString:@""];
//        }
    }
    
    return string;
}

- (NSString *)stringByRemovingHTMLMarkWithoutImage {
    NSString *string = [self replaceSpecialCharacter];
    
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString * HTMLmark = nil;
    
    while(![scanner isAtEnd]) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&HTMLmark];
        //替换字符
        if (![HTMLmark hasPrefix:@"<img"] && ![HTMLmark hasPrefix:@"<p"]) {//不包含属性
            string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",HTMLmark] withString:@""];
        }
    }
    
    return string;
}

+ (NSString *)generatesRandomStringWithLength:(int)length {
    
    char data[length];
    
    for (int x=0; x < length; data[x ++] = (char)('A' + (arc4random_uniform(26))));
    
    NSString *randomString =[[NSString alloc]initWithBytes:data length:length encoding:NSUTF8StringEncoding];
    
    return randomString;
    
}

+ (NSString *)stringByJSONObject:(id)JSONObject {
    
    NSString *JSONString = nil;
    
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:NSJSONWritingPrettyPrinted error:nil];
        JSONString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }else {
        
        NSLog(@"Error! Not is valid JSONObject.");
        
    }
    
    return JSONString;
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param JSONString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryByJSONString:(NSString *)JSONString {
    
    JSONString =[JSONString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    if (JSONString == nil) {
        
        return nil;
        
    }
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    
    if(error) {
        
        NSLog(@"JSON解析失败：%@",error);
        
        return nil;
        
    }
    
    return dictionary;
    
}

- (NSString *)sha1 {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)md5 {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11)
    {
        return NO;
    }
    return YES;
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,166,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|6[6]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)stringDateWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *)dateStringForTimeStampWithDateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL)dateStringCompareWithForDateFormat:(NSString *)dateFormat stratDateString:(NSString *)stratDateString endDateString:(NSString *)endDateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *activitiesstarttime = [dateFormatter dateFromString:stratDateString];
    NSDate *activitiesendtime = [dateFormatter dateFromString:endDateString];
    NSDate *date = [dateFormatter dateFromString:self];
    
    if ([date compare:activitiesstarttime] == 1 && [date compare:activitiesendtime] == -1) {
        
        return YES;
        
    }else {
        
        return NO;
        
    }
    
}

- (NSString *)encryptionUserName {
    NSString *userNameString;
    if ([NSString isMobileNumber:self]) {//当用户名是电话号码时
        userNameString = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else if (self.length < 3) {//用户名过短，不处理
        userNameString = self;
    } else {//用户名适中，掐头去尾，中间至多留3个*
        if (self.length-2 == 1) {
            userNameString = [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length-2) withString:@"*"];
        } else if (self.length-2 == 2) {
            userNameString = [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length-2) withString:@"**"];
        } else if (self.length-2 >= 3) {
            userNameString = [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length-2) withString:@"***"];
        }
    }
    
    return userNameString;
}



/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

#pragma mark - html标签处理
+ (NSString *)stringPretreatmentWithString:(NSString *)string {
    string = [string stringByRemovingHTMLMarkWithoutImage];
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return string;
}

+ (NSArray *)arrayPretreatmentWithImgString:(NSString *)string{
    NSMutableArray *viewArray = [NSMutableArray new];
    //循环加入图片字典或文本字符串
    //循环的意义在于某些返回数据中存在多张图片或图片+文本的形式
    [self circleWithImgString:string forViewArray:viewArray];
    
    return viewArray;
}

+ (void)circleWithImgString:(NSString *)string forViewArray:(NSMutableArray *)viewArray{
    if (string.length == 0) {
        return;
    }
    NSLog(@"orignString%@", string);
    
    if ([string containsString:@"<p"]) {//包含p标签的替换为换行符
        //通过range获取对应的p标签字符串
        NSRange preRange = [string rangeOfString:@"<p"];
        //存在<p>非开头的情况，需要查询'<p'之后结尾的'>'，否则报错
        NSString *stringWithoutPMark = [string substringWithRange:NSMakeRange(preRange.location, string.length-preRange.location)];
        NSRange sufRange = [stringWithoutPMark rangeOfString:@">"];
        NSString *pMark = [string substringWithRange:NSMakeRange(preRange.location, sufRange.location+sufRange.length)];
        string = [string stringByReplacingOccurrencesOfString:pMark withString:@"\n"];
        
        [self circleWithImgString:string forViewArray:viewArray];
    } else if ([string hasPrefix:@"<img"]) {
        //通过range获取对应的img字符串
        NSRange sufRange = [string rangeOfString:@"/>"];
        
        NSString *imgMark = [string substringWithRange:NSMakeRange(0, sufRange.length + sufRange.location)];
        
        //替换字符
        if ([imgMark containsString:@"img"]) {
            [viewArray addObject:[self dictionaryPretreatmentWithImgString:imgMark]];
            string = [string stringByReplacingCharactersInRange:NSMakeRange(0, sufRange.length + sufRange.location) withString:@""];
        }
        [self circleWithImgString:string forViewArray:viewArray];
    } else {
        if ([string containsString:@"img"]) {//不以图片开头
            //通过range获取对应label的文本字符串
            NSRange sufRange = [string rangeOfString:@"<img"];
            //以<img结尾
            NSString *labelStr = [string substringWithRange:NSMakeRange(0, sufRange.location)];
            if (![labelStr isEqualToString:@"\n"]) {//还包含图片信息的不计入换行
                [viewArray addObject:labelStr];
            }
            string = [string stringByReplacingCharactersInRange:NSMakeRange(0, sufRange.location) withString:@""];
            [self circleWithImgString:string forViewArray:viewArray];
        } else {
            [viewArray addObject:string];
            string = [string stringByReplacingOccurrencesOfString:string withString:@""];
            NSLog(@"%@", string);
            
            return;
        }
    }
}

+ (NSDictionary *)dictionaryPretreatmentWithImgString:(NSString *)string{
    /*根据图片的jsx文本，返回一个字典，.eg:
     *{
     *  img =     {
     *      alt = "";
     *      height = 123;
     *      src = "";
     *      width = 123;
     *  };
     *}
     */
    __block NSMutableDictionary *imgDict = [[NSMutableDictionary alloc] init];
    __block NSMutableDictionary *imgAttributeDict = [[NSMutableDictionary alloc] init];
    
    NSArray *imgArr = [string componentsSeparatedByString:@" "];
    
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)obj;
            
            *stop = [str containsString:@"/>"];
            
            NSString *keyString;
            if ([str containsString:@"<"]) {
                
                keyString = [string substringWithRange:NSMakeRange(1, str.length - 1)];//去除<
                [imgDict setObject:imgAttributeDict forKey:keyString];
                
            } else if ([str containsString:@"=\""]) {//只用=会有问题（当参数中有=时   .eg : id=...）
                
                if (*stop) {//最后一个元素
                    str = [str substringWithRange:NSMakeRange(0, str.length - 2)];//去掉最后的/>
                }
                
                NSRange sufRange = [str rangeOfString:@"=\""];
                
                keyString = [str substringWithRange:NSMakeRange(0, sufRange.location)];
                
                NSString *valueString = [str substringWithRange:NSMakeRange(sufRange.location + 2, str.length - sufRange.location - sufRange.length - 1)];
                
                [imgAttributeDict setObject:valueString forKey:keyString];
            }
        }
    }];
    
    return imgDict;
}

@end
