<?php
include('/usr/local/src/smarty/smarty_setup.php');

$it = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($templatePath));
foreach ($it as $fileInfo) {
    if ($fileInfo->isFile()) {

        $relativePath = substr($fileInfo->getPath(), strlen($templatePath));

        if ($fileInfo->getExtension() == 'tpl') {
            // Write out computed file from template
            $relativeFileName = $relativePath . DIRECTORY_SEPARATOR . $fileInfo->getFilename();
            $absoluteFilePath = DIRECTORY_SEPARATOR . substr($relativeFileName, 0, -4);
            echo "Processing template $relativeFileName to $absoluteFilePath\n";
            $computed_file = fopen($absoluteFilePath, "w");
            if ($computed_file) {
                fwrite($computed_file, $smarty->fetch($relativeFileName));
                fclose($computed_file);
            } else {
                die('Failure opening output file: ' . $absoluteFilePath);
            }
        } else {
            echo "Copying file " . $fileInfo->getPath() . DIRECTORY_SEPARATOR . $fileInfo->getFilename() .
            " to " . DIRECTORY_SEPARATOR . $relativePath . DIRECTORY_SEPARATOR . $fileInfo->getFilename() . "\n";
            // Simply copy the file.
            if (!copy(
                $fileInfo->getPath() . DIRECTORY_SEPARATOR . $fileInfo->getFilename(),
                DIRECTORY_SEPARATOR . $relativePath . DIRECTORY_SEPARATOR . $fileInfo->getFilename()
            )) {
                die('Failed copying file.');
            }
        }
    }
}
