import 'dart:io';
import 'package:equatable/equatable.dart';

import '../../models/how_to_cook_model.dart';
import '../../models/ingredients_model.dart';

abstract class NewRecipeState extends Equatable {
  const NewRecipeState();

  @override
  List<Object> get props => [];
}

class NewRecipeInitial extends NewRecipeState {
  @override
  List<Object> get props => [];
}

class NewRecipeLoading extends NewRecipeState {}

class NewRecipeAddImageMainSuccess extends NewRecipeState {
  final File file;
  NewRecipeAddImageMainSuccess(this.file);
  @override
  List<Object> get props => [file];
}

class NewRecipeAddImageMainFailure extends NewRecipeState {}

class NewRecipeAddImageGallerySuccess extends NewRecipeState {
  final List<File> listFile;
  NewRecipeAddImageGallerySuccess(this.listFile);
  @override
  List<Object> get props => [listFile];
}

class NewRecipeAddImageGalleryFailure extends NewRecipeState {}

class NewRecipeAddImageIngredientSuccess extends NewRecipeState {
  final File file;
  NewRecipeAddImageIngredientSuccess(this.file);
  @override
  List<Object> get props => [file];
}

class NewRecipeAddImageIngredientFailure extends NewRecipeState {}

class NewRecipeAddIngredientSuccess extends NewRecipeState {
  final IngredientModel ingredient;
  NewRecipeAddIngredientSuccess(this.ingredient);
  @override
  List<Object> get props => [ingredient];
}

class NewRecipeAddIngredientFailure extends NewRecipeState {}

class NewRecipeAddLinkHowToCookSuccess extends NewRecipeState {
  final String directions;
  NewRecipeAddLinkHowToCookSuccess(this.directions);
  @override
  List<Object> get props => [directions];
}

class NewRecipeAddLinkHowToCookFailure extends NewRecipeState {}

class NewRecipeAddStepHowToCookSuccess extends NewRecipeState {
  final HowToCookModel listStep;
  NewRecipeAddStepHowToCookSuccess(this.listStep);
  @override
  List<Object> get props => [listStep];
}

class NewRecipeAddStepHowToCookFailure extends NewRecipeState {}

class NewRecipeCategoriesLoadSuccess extends NewRecipeState {
  final List<Map<String, dynamic>> categoriesAndTotalRecipes;
  const NewRecipeCategoriesLoadSuccess(
      {required this.categoriesAndTotalRecipes});
}

class NewRecipeCategoriesLoadFailure extends NewRecipeState {}

class NewRecipeSaveRecipeSuccess extends NewRecipeState {}

class NewRecipeSaveRecipeFailure extends NewRecipeState {
  final String mainImageErrorMessage;
  final String recipeNameErrorMessage;
  final String galleryErrorMessage;
  final String ingredientsErrorMessage;
  final String howToCookErrorMessage;

  const NewRecipeSaveRecipeFailure({
    this.mainImageErrorMessage = '',
    this.recipeNameErrorMessage = '',
    this.galleryErrorMessage = '',
    this.ingredientsErrorMessage = '',
    this.howToCookErrorMessage = '',
  });
}
