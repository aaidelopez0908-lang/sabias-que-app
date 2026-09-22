//
//  ViewController.m
//  SabiasQue
//
//  Proyecto: Diseño y desarrollo de aplicación iOS
//  Descripción: Interfaz principal de la app ¿Sabías qué?
//
//  Funcionamiento:
//  1. El usuario selecciona una de tres categorías (Animales, Espacio, Historia).
//  2. Al tocar el botón, se muestra un dato curioso de esa categoría.
//  3. Al tocar nuevamente el botón, se muestra un dato distinto de la misma categoría.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *categorySegment;
@property (nonatomic, strong) UILabel *factLabel;
@property (nonatomic, strong) UIButton *showFactButton;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *factsByCategory;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *lastIndexByCategory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"¿Sabías qué?";

    [self setupData];
    [self setupUI];
}

#pragma mark - Datos

- (void)setupData {
    self.factsByCategory = @{
        @"Animales": @[
            @"El corazón de una jirafa puede pesar hasta 11 kilogramos.",
            @"Las mariposas pueden saborear con sus patas.",
            @"Los pulpos tienen tres corazones.",
            @"Los delfines tienen nombres propios para llamarse entre ellos."
        ],
        @"Espacio": @[
            @"Un día en Venus dura más que un año en Venus.",
            @"El Sol representa más del 99% de la masa de todo el Sistema Solar.",
            @"En gravedad cero, los astronautas pueden crecer hasta 5 cm de estatura.",
            @"Hay más estrellas en el universo que granos de arena en todas las playas de la Tierra."
        ],
        @"Historia": @[
            @"La Torre Eiffel puede crecer hasta 15 cm en verano por efecto del calor.",
            @"Cleopatra vivió más cerca en el tiempo de la llegada del hombre a la Luna que de la construcción de las pirámides de Guiza.",
            @"La Primera Guerra Mundial terminó oficialmente en 1919, no en 1918.",
            @"Oxford University es más antigua que el Imperio Azteca."
        ]
    };

    self.lastIndexByCategory = [NSMutableDictionary dictionary];
    for (NSString *category in self.factsByCategory) {
        self.lastIndexByCategory[category] = @(-1);
    }
}

#pragma mark - Interfaz

- (void)setupUI {
    NSArray<NSString *> *categories = @[@"Animales", @"Espacio", @"Historia"];

    self.categorySegment = [[UISegmentedControl alloc] initWithItems:categories];
    self.categorySegment.selectedSegmentIndex = 0;
    self.categorySegment.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.categorySegment];

    self.factLabel = [[UILabel alloc] init];
    self.factLabel.numberOfLines = 0;
    self.factLabel.textAlignment = NSTextAlignmentCenter;
    self.factLabel.font = [UIFont systemFontOfSize:18];
    self.factLabel.textColor = [UIColor labelColor];
    self.factLabel.text = @"Selecciona una categoría y presiona el botón para ver un dato curioso.";
    self.factLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.factLabel];

    self.showFactButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showFactButton setTitle:@"Mostrar dato curioso" forState:UIControlStateNormal];
    self.showFactButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.showFactButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.showFactButton addTarget:self
                             action:@selector(showFactTapped)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showFactButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.categorySegment.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:24],
        [self.categorySegment.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.categorySegment.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],

        [self.factLabel.topAnchor constraintEqualToAnchor:self.categorySegment.bottomAnchor constant:40],
        [self.factLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.factLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],

        [self.showFactButton.topAnchor constraintEqualToAnchor:self.factLabel.bottomAnchor constant:40],
        [self.showFactButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];
}

#pragma mark - Acciones

- (void)showFactTapped {
    NSString *category = [self.categorySegment titleForSegmentAtIndex:self.categorySegment.selectedSegmentIndex];
    NSArray<NSString *> *facts = self.factsByCategory[category];

    NSInteger lastIndex = [self.lastIndexByCategory[category] integerValue];
    NSInteger newIndex;
    do {
        newIndex = arc4random_uniform((uint32_t)facts.count);
    } while (facts.count > 1 && newIndex == lastIndex);

    self.lastIndexByCategory[category] = @(newIndex);
    self.factLabel.text = facts[newIndex];
}

@end
