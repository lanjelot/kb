# test credit card numbers

panhunt

try this with grep:
^(?:4[0-9]{12}(?:[0-9]{3})?          # Visa
 |  5[1-5][0-9]{14}                  # MasterCard
 |  3[47][0-9]{13}                   # American Express
 |  3(?:0[0-5]|[68][0-9])[0-9]{11}   # Diners Club
 |  6(?:011|5[0-9]{2})[0-9]{12}      # Discover
 |  (?:2131|1800|35\d{3})\d{11}      # JCB
)$

http://www.paypalobjects.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm
http://creditcardjs.com/credit-card-type-detection
https://github.com/NetSPI/PS_CC_Checker
https://github.com/eelsivart/SearchForCC (has some grep REs)

CC numbers:
less: [^0-9][3456][0-9]\{3\}[[:space:]-]*[0-9]\{4\}[[:space:]-]*[0-9]\{4\}[[:space:]-]*[0-9]\{4\}[^0-9]
grep -Eo '[^0-9][3456][0-9]{3}[[:space:]-]*[0-9]{4}[[:space:]-]*[0-9]{4}[[:space:]-]*[0-9]{4}[^0-9]'

track data:
grep -Eo '[3-6][0-9]{15}=[0-9]{20}?'


