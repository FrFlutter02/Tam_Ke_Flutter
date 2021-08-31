import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/login_bloc/login_bloc.dart';
import '../blocs/login_bloc/login_event.dart';
import '../blocs/login_bloc/login_state.dart';
import '../models/category.dart';
import '../widgets/custom_button.dart';
import '../blocs/new_recipe_bloc/new_recipe_event.dart';
import '../models/gallery_model.dart';
import '../blocs/new_recipe_bloc/new_recipe_bloc.dart';
import '../blocs/new_recipe_bloc/new_recipe_state.dart';
import '../widgets/new_recipe/item_new_how_to_cook.dart';
import '../widgets/new_recipe/bottom_sheet_pick_image.dart';
import '../widgets/new_recipe/item_new_gallery.dart';
import '../widgets/new_recipe/item_new_ingredients.dart';
import '../constants/constant_colors.dart';
import '../constants/constant_text.dart';
import '../widgets/new_recipe/item_new_additional_info.dart';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({Key? key}) : super(key: key);

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

enum ImageType { imageMain, imageForGallery, imageForIngredient }

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final nameRecipeController = TextEditingController();
  final categoryController = TextEditingController();
  final GlobalKey dropdownKey = GlobalKey();
  String dropdownValue = '';
  bool isTablet = false;
  File imageMain = File('');
  List<GalleryModel> galleryList = [];
  List<CategoryModel> categories = [];
  String user = "";
  bool addCategory = false;
  StreamSubscription? authenStreamSubscription;
  StreamSubscription? recipeStreamSubscriptionNew;

  @override
  void initState() {
    context.read<LoginBloc>().add(LogInGetUserRequested());
    authenStreamSubscription =
        context.read<LoginBloc>().stream.listen((loginState) {
      if (loginState is LoginGetUserSuccess) {
        user = loginState.user.email!;
        context
            .read<NewRecipeBloc>()
            .add(NewRecipeGetCategoriesRequested(user));
        recipeStreamSubscriptionNew =
            context.read<NewRecipeBloc>().stream.listen((newRecipeState) {
          if (newRecipeState is NewRecipeCategoriesLoadSuccess &&
              newRecipeState.categories.isNotEmpty) {
            categories = newRecipeState.categories;
            dropdownValue = categories[0].categoryName;
            categories.add(CategoryModel(categoryName: "", totalRecipes: 0));
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    authenStreamSubscription?.cancel();
    recipeStreamSubscriptionNew?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Device.get().isTablet) {
      isTablet = true;
    }

    return Scaffold(
      body: SingleChildScrollView(
          child: BlocConsumer<NewRecipeBloc, NewRecipeState>(
        builder: (context, state) {
          return Stack(children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: isTablet ? 76.h : 30.h,
                      left: isTablet ? 113.w : 20.w,
                      bottom: 15.h),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left_outlined),
                        Text(
                          NewRecipeText.leadingText,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: NewRecipeScreenColor.leadingTextColor),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isTablet ? 118.w : 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTablet
                            ? NewRecipeText.titleTabletText
                            : NewRecipeText.titleText,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: AppColor.primaryBlack,
                            height: 1.33,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: isTablet ? 25.h : 33.h),
                      Row(
                        children: [
                          Container(
                            height: 62.w,
                            width: 62.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      NewRecipeScreenColor.borderButtonColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  primary: AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => BottomSheetPickImage(
                                          typeImage: ImageType.imageMain,
                                        )),
                                  );
                                },
                                child: imageMain.path == ""
                                    ? Image.asset(
                                        "assets/images/icons/plus_icon.png")
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(imageMain.path),
                                          fit: BoxFit.fill,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      )),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    NewRecipeText.labelRecipeNameText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            height: 1.57,
                                            color: AppColor.secondaryGrey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: SizedBox(
                                      height: isTablet ? 22.h : 20.h,
                                      child: TextField(
                                        controller: nameRecipeController,
                                        cursorColor: AppColor.green,
                                        decoration: InputDecoration(
                                          hintText:
                                              NewRecipeText.hintRecipeNameText,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColor.green,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ItemNewGallery(),
                      ItemNewIngredients(),
                      ItemNewHowToCook(),
                      ItemNewAdditionalInfo(),
                      SizedBox(height: isTablet ? 50.h : 20.h),
                      Text(
                        NewRecipeText.saveToText,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: AppColor.primaryGrey,
                              height: 1.57,
                            ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        children: [
                          Container(
                              width: 190.w,
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: addCategory
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (categoryController
                                                    .text.isEmpty) return;
                                                categories.insert(
                                                    categories.length - 1,
                                                    CategoryModel(
                                                        categoryName:
                                                            categoryController
                                                                .text,
                                                        totalRecipes: 0));
                                                dropdownValue =
                                                    categoryController.text;
                                                categoryController.text = "";
                                                addCategory = false;
                                              });
                                            },
                                            child: Icon(Icons.add_outlined)),
                                        SizedBox(
                                            width: 120,
                                            height: 30,
                                            child: TextField(
                                              controller: categoryController,
                                              cursorColor: AppColor.green,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColor.green,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                                  : DropdownButton<String>(
                                      key: dropdownKey,
                                      value: dropdownValue,
                                      icon: Icon(Icons.expand_more_outlined),
                                      iconSize: 23,
                                      isExpanded: true,
                                      style: const TextStyle(
                                          color: AppColor.primaryBlack),
                                      underline: SizedBox(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      items: categories
                                          .map<DropdownMenuItem<String>>(
                                              (CategoryModel element) {
                                        return DropdownMenuItem<String>(
                                          value: element.categoryName,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (element.categoryName == '')
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      addCategory = true;
                                                    });
                                                  },
                                                  child: ((Text(
                                                    NewRecipeText
                                                        .AddNewCategoryText,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                            color:
                                                                AppColor.green),
                                                  ))),
                                                )
                                              else
                                                (Text(
                                                    "${element.categoryName} (${element.totalRecipes})"))
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )),
                          SizedBox(width: 15.w),
                          SizedBox(
                            height: 50.h,
                            width: isTablet ? 155.w : 120.w,
                            child: OutlinedButton(
                                onPressed: () async {
                                  context.read<NewRecipeBloc>().add(
                                      NewRecipeSaved(nameRecipeController.text,
                                          dropdownValue, user));
                                },
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: AppColor.green, width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  NewRecipeText.saveRecipeText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: AppColor.green,
                                        letterSpacing: 0.32,
                                        height: 1.37,
                                      ),
                                )),
                          ),
                          SizedBox(width: isTablet ? 15.w : 0.w),
                          Container(
                            margin: EdgeInsets.only(top: isTablet ? 0.h : 30.h),
                            child: CustomButton(
                              height: 50.h,
                              width: isTablet ? 155.w : double.infinity,
                              value: NewRecipeText.postToFeedText,
                              buttonOnPress: () {
                                print(user);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 70.h : 36.h),
                    ],
                  ),
                ),
              ],
            ),
            if (state is NewRecipeLoading)
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: (Container(
                      width: 1.sw,
                      height: 1.sh,
                      color: Colors.grey.withOpacity(0.2),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.green,
                        ),
                      ))))
          ]);
        },
        listener: (context, state) {
          print(state);
          switch (state.runtimeType) {
            case NewRecipeAddImageMainSuccess:
              state as NewRecipeAddImageMainSuccess;
              setState(() {
                imageMain = state.file;
              });
              break;
            case NewRecipeSaveRecipeSuccess:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(NewRecipeText.saveNewRecipeSuccessText),
              ));
              break;
            case NewRecipeValidateFailure:
              state as NewRecipeValidateFailure;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "${state.props.where((e) => e.toString().isNotEmpty).join(', ')} should not be empty"),
              ));
              break;
          }
        },
      )),
    );
  }
}
