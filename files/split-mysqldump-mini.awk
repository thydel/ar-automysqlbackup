BEGIN { FS = "`"; n = "head" }
/^-- Table structure for table `.*`$/ { n = $2 }
{ print > n ".sql" }
