Function ConvertBytes {
    param($Size)

    $SizeOut = $null

    if ($Size -lt 1MB) {
        $SizeOut = $Size / 1KB
        $SizeOut = [Math]::Round($SizeOut, 2)
        [String]$SizeOut + " KB"
    } elseif ($Size -lt 1GB) {
        $SizeOut = $Size / 1MB
        $SizeOut = [Math]::Round($SizeOut, 2)
        [String]$SizeOut + " MB"
    } elseif ($Size -lt 1TB) {
        $SizeOut = $Size / 1GB
        $SizeOut = [Math]::Round($SizeOut, 2)
        [String]$SizeOut + " GB"
    } elseif ($Size -lt 1PB) {
        $SizeOut = $Size / 1TB
        $SizeOut = [Math]::Round($SizeOut, 2)
        [String]$SizeOut + " TB"
    } else {
        $SizeOut = $Size / 1PB
        $SizeOut = [Math]::Round($SizeOut, 2)
        [String]$SizeOut + " PB"
    }
}
