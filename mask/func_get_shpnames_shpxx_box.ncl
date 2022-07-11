undef("get_shpnames_shpxx_box")
function get_shpnames_shpxx_box(region:string)
local shpNames, shpXX, box

begin

if (region .eq. "EUR") then
  shpNames=(/ "Ireland",      "UnitedKingdom",  "Norway",     "Sweden",     "Finland",      \
              "Estonia",      "Latvia",         "Lithuania",  "Belarus",    "Ukraine",      \
              "Italy",        "Romania",        "Bulgaria",   "Poland",     "Netherlands",  \
              "Belgium",      "France",         "Spain",      "Portugal",   "Germany",      \
              "Switzerland",  "CzechRepublic",  "Slovakia",   "Hungary",    "Austria",      \
              "Slovenia",     "Croatia",        "Serbia",     "Kosova",     "Macedonia",    \
              "Albania",      "Greece",         "Turkey",     "Moldova",    "Denmark",      \
              "Luxembourg"                                                                  /)
  shpXX   =(/ "IRL",          "GBR",            "NOR",        "SWE",        "FIN",          \
              "EST",          "LVA",            "LTU",        "BLR",        "UKR",          \
              "ITA",          "ROU",            "BGR",        "POL",        "NLD",          \
              "BEL",          "FRA",            "ESP",        "PRT",        "DEU",          \
              "CHE",          "CZE",            "SVK",        "HUN",        "AUT",          \
              "SVN",          "HRV",            "SRB",        "XKO",        "MKD",          \
              "ALB",          "GRC",            "TUR",        "MDA",        "DNK",          \
              "LUX"                                                                         /)
  box = (/34., 72., -12., 46./)  ;latS, latN, lonW, lonE
end if

if (region .eq. "ARG") then
  shpNames=(/"BuenosAires",    "Cordoba",      "Catamarca",   "Chaco",      "Chubut",        \
             "Corrientes",     "EntreRios",    "Formosa",     "Jujuy",      "LaPampa",       \
             "LaRioja",        "Mendoza",      "Misiones",    "Neuquen",    "RioNegro",      \
             "Salta",          "SanJuan",      "SanLuis",     "SantaCruz",  "SantaFe",       \
             "SantiagoEstero", "Tucuman"        /)
  shpXX   =(/"BA",             "CB",           "CT",          "CC",         "CH",            \
             "CR",             "ER",           "FO",          "JY",         "LP",            \
             "LR",             "MZ",           "MN",          "NQ",         "RN",            \
             "SA",             "SJ",           "SL",          "SC",         "SF",            \
             "SE",             "TM"                                                          /)
  box = (/-53, -21, 286, 307/)
end if

if (region .eq. "AUS") then
  shpNames= (/ "NewSouthWales",     "NorthernTerritory",   "Queensland",       "SouthAustralia",     \
               "Tasmania",          "Victoria",            "WesternAustralia"                        /)
  shpXX   = (/ "NSW",               "NT",                  "QLD",              "SA",                 \
               "TAS",               "VIC",                 "WA"                                      /)
  box = (/-45., -8., 110, 155/)
end if

if (region .eq. "BRA") then
  shpNames=(/"Acre",              "Alagoas",            "Amapa",               "Amazonas",            \
             "Bahia",             "Ceara",              "EspiritoSanto",       "Goias",               \
             "Maranhao",          "MatoGrossoSul",      "MatoGrosso",          "MinasGerais",         \
             "Para",              "Paraiba",            "Parana",              "Pernambuco",          \
             "Piaui",             "RioJaneiro",         "RioGrandeNorte",      "RioGrandeSul",        \
             "Rondonia",          "Roraima",            "SaoPaulo",            "SantaCatarina",       \
             "Sergipe",           "Tocantins"                                                         /)
  shpXX   =(/"AC",                "AL",                 "AP",                  "AM",                  \
             "BA",                "CE",                 "ES",                  "GO",                  \
             "MA",                "MS",                 "MT",                  "MG",                  \
             "PA",                "PB",                 "PR",                  "PE",                  \
             "PI",                "RJ",                 "RN",                  "RS",                  \
             "RO",                "RR",                 "SP",                  "SC",                  \
             "SE",                "TO"                                                                /)
  box = (/-34., 9.5, 285., 326./)
end if

if (region .eq. "CAN") then
  shpNames=(/"Alberta",          "BritishColumbia",        "Monitoba",       \
             "NewBrunswick",     "NewfoundlandLabrador",   "NovaScotia",     \
             "Ontario",          "Quebec",                 "Saskatchewan"    /)
  shpXX   =(/"AB",               "BC",                     "MB",             \
             "NB",               "NL",                     "NS",             \
             "ON",               "QC",                     "SK"              /)
  box = (/40.4, 63., 220., 310./) 
end if

if (region .eq. "CHN") then
  shpNames=(/"Anhui",         "Beijing",  "Chongqing", "Fujian",   "Gansu",   \
             "Guangdong",     "Guangxi",  "Guizhou",   "Hainan",   "Hebei",   \
             "Heilongjiang",  "Henan",    "Hubei",     "Hunan",    "Jiangsu", \
             "Jiangxi",       "Jilin",    "Liaoning",  "Neimeng",  "Ningxia", \
             "Qinghai",       "Shaanxi",  "Shandong",  "Shanghai", "Shanxi",  \
             "Sichuan",       "Tianjin",  "Xinjiang",  "Xizang",   "Yunnan",  \
             "Zhejiang"                                                       /)
  shpXX   =(/"AH",            "BJ",       "CQ",        "FJ",       "GS",      \
             "GD",            "GX",       "GZ",        "HaiN",     "HeB",     \
             "HLJ",           "HeN",      "HuB",       "HuN",      "JS",      \
             "JX",            "JL",       "LN",        "NM",       "NX",      \
             "QH",            "SaX",      "SD",        "SH",       "SX",      \
             "SC",            "TJ",       "XJ",        "XZ",       "YN",      \
             "ZJ"                                                             /)
  box = (/17., 55., 72., 147./)
end if


if (region .eq. "IDN" ) then
  shpNames=(/"Aceh",             "Bangka-Belitung",    "Banten",            \
             "Bengkulu",         "Gorontalo",          "WestPapua",         \
             "Jambi",            "JawaBarat",          "JawaTengah",        \
             "JawaTimur",        "KalimantanBarat",    "KalimantanSelatan", \
             "KalimantanTengah", "KalimantanTimur",    "KalimantanUtara",   \
             "Lampung",          "Papua",              "Riau",              \
             "SulawesiBarat",    "SulawesiSelatan",    "SulawesiTengah",    \
             "SulawesiTenggara", "SulawesiUtara",      "SumateraBarat",     \
             "SumateraSelatan",  "SumateraUtara"                            /)
  shpXX   =(/"AC",               "BB",                 "BT",                \
             "BE",               "GO",                 "PB",                \
             "JA",               "JB",                 "JT",                \
             "JI",               "KB",                 "KS",                \
             "KT",               "KI",                 "KU",                \
             "LA",               "PA",                 "RI",                \
             "SR",               "SN",                 "ST",                \
             "SG",               "SA",                 "SB",                \
             "SS",               "SU"                                       /)
  box = (/-12., 7, 94., 142./)
end if

if (region .eq. "IND") then 
  shpNames=(/ "AndhraPradesh",        "ArunachalPradesh",        "Assam",               \
              "Bihar",                "Chhattisgarh",            "Gujarat",             \
              "Haryana",              "HimachalPradesh",         "JammuKashmir",        \
              "Jharkhand",            "Karnataka",               "Kerala",              \
              "MadhyaPradesh",        "Maharashtra",             "Manipur",             \
              "Meghalaya",            "Mizoram",                 "Nagaland",            \
              "Odisha",               "Punjab",                  "Rajasthan",           \
              "Sikkim",               "TamilNadu",               "Telangana",           \
              "Tripura",              "UttarPradesh",            "Uttarakhand",         \
              "WestBengal"                                                              /)
  shpXX    =(/"AP",                   "AR",                      "AS",                  \
              "BR",                   "CT",                      "GJ",                  \
              "HR",                   "HP",                      "JK",                  \
              "JH",                   "KA",                      "KL",                  \
              "MP",                   "MH",                      "MN",                  \
              "ML",                   "MZ",                      "NL",                  \
              "OR",                   "PB",                      "RJ",                  \
              "SK",                   "TN",                      "TG",                  \
              "TR",                   "UP",                      "UT",                  \
              "WB"                                                                      /)
  box = (/6., 37., 67., 98/)
end if

if (region .eq. "MYS") then 
  shpNames=(/"Johor",         "Kedah",    "Kelantan",  "Melaka",  "NegeriSembilan",  \
             "Pahang",        "Perak",    "Sabah",     "Sarawak", "Selangor",        \
             "Terengganu"                                                            /)
  shpXX   =(/"JHR",           "KDH",      "KTN",       "MLK",     "NSN",             \
             "PHG",           "PRK",      "SBH",       "SWK",     "SGR",             \
             "TRG"                                                                   /)
  box = (/0, 8., 99., 120./)
end if

if (region .eq. "USA") then
  shpNames=(/"Alabama",           "Arizona",           "Arkansas",           "California",          \
             "Colorado",          "Connecticut",       "Delaware",           "Florida",             \
             "Georgia",           "Idaho",             "Illinois",           "Indiana",             \
             "Iowa",              "Kansas",            "Kentucky",           "Louisiana",           \
             "Maine",             "Maryland",          "Massachusetts",      "Michigan",            \
             "Minnesota",         "Mississippi",       "Missouri",           "Montana",             \
             "Nebraska",          "Nevada",            "NewHampshire",       "NewJersey",           \
             "NewMexico",         "NewYork",           "NorthCarolina",      "NorthDakota",         \
             "Ohio",              "Oklahoma",          "Oregon",             "Pennsylvania",        \
             "RhodeIsland",       "SouthCarolina",     "SouthDakota",        "Tennessee",           \
             "Texas",             "Utah",              "Vermont",            "Virginia",            \
             "Washington",        "WestVirginia",      "Wisconsin",          "Wyoming"              /)
  shpXX   =(/"AL",                "AZ",                "AR",                 "CA",                  \
             "CO",                "CT",                "DE",                 "FL",                  \
             "GA",                "ID",                "IL",                 "IN",                  \
             "IA",                "KS",                "KY",                 "LA",                  \
             "ME",                "MD",                "MA",                 "MI",                  \
             "MN",                "MS",                "MO",                 "MT",                  \
             "NE",                "NV",                "NH",                 "NJ",                  \
             "NM",                "NY",                "NC",                 "ND",                  \
             "OH",                "OK",                "OR",                 "PA",                  \
             "RI",                "SC",                "SD",                 "TN",                  \
             "TX",                "UT",                "VT",                 "VA",                  \
             "WA",                "WV",                "WI",                 "WY"                   /)
  box = (/24., 55., 234., 294./)
end if

return([/shpNames,shpXX,box/])

end