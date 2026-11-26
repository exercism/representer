class WordCount {
    List words

    WordCount(sentence) {
        this.words = sentence.normalize().toLowerCase().findAll(/\w+('[a-z]+)?/)
    }

    def countWords() {
        this.words.countBy{it}
    }
}
