enum Categoria {
  cocktail,
  cocktailAnalcolico,
  birreInBottiglia,
  distillatiRum,
  whisky,
  bottiglie,
  amari,
  longDrinkPremium,
  longDrinkSilver,
  longDrinkGold,
  longDrinkLuxury,
  particularyDrink,
  drinkAnalcolici,
}

extension CategoriaExtension on Categoria {
  String get label {
    switch (this) {
      case Categoria.cocktail:
        return "Cocktails";
      case Categoria.cocktailAnalcolico:
        return "Cocktails Analcolici";
      case Categoria.birreInBottiglia:
        return "Birre in Bottiglia";
      case Categoria.distillatiRum:
        return "Distillati & Rum";
      case Categoria.whisky:
        return "Whisky";
      case Categoria.bottiglie:
        return "Bottiglie";
      case Categoria.amari:
        return "Amari";
      case Categoria.longDrinkSilver:
        return "Long Drink - Silver";
      case Categoria.longDrinkGold:
        return "Long Drink - Gold";
      case Categoria.longDrinkPremium:
        return "Long Drink - Premium";
      case Categoria.longDrinkLuxury:
        return "Long Drink - Luxury";
      case Categoria.particularyDrink:
        return "Particulary Drink";
      case Categoria.drinkAnalcolici:
        return "Drink Analcolici";
    }
  }
}
