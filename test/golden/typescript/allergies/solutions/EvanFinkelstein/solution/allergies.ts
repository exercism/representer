const allergenList: {[key: string]: number} ={
  cats:128,
  pollen:64,
  chocolate:32,
  tomatoes:16,
  strawberries:8,
  shellfish:4,
  peanuts:2,
  eggs:1
} 
export class Allergies {
  private allergenIndex: number 
  constructor(allergenIndex: number) {
    this.allergenIndex = allergenIndex % 256 ? allergenIndex % 256 : allergenIndex
 }
  public list(): string[] {
    return Object.keys(allergenList).flatMap(item => {
      return this.allergicTo(item) ? item : []
    }).reverse()    
  }
  public allergicTo(allergen: string): boolean {
    const allergenNumber:number = allergenList[allergen]
    const indexNumber:number = this.allergenIndex - allergenNumber
      if(indexNumber >= 0 && indexNumber !=  allergenNumber ){
         this.allergenIndex -= allergenNumber
         return true
      }
         return false
 }
}
