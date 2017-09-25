echo "Rendering slides..."
for file in `ls Slides/*.md`
do
    if [ "$file" -nt "$file.pdf" ]; then
        echo "... $file"
        rm $file.pdf
        pandoc -t beamer -o "$file.pdf" "$file"
    fi
done

echo " "

echo "Rendering book..."
rm Compilers.pdf;
pandoc --toc -H Meta/Header.tex --filter ./Filters/trees.py -V lang=es -o Compilers.pdf Meta/Metadata.yaml `ls Content/*.md`;
echo "Done"
