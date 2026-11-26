class Anagram {

    def subject

    Anagram(subject){
      this.subject = subject
    }

    def find(candidates) {
      candidates.findAll{it->(it.toLowerCase().split("")!=subject.toLowerCase().split(""))&&(it.toLowerCase().split("").sort()==subject.toLowerCase().split("").sort())}
    }
}