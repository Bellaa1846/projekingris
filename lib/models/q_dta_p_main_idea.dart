import 'question_model.dart';

final List<Question> mainIdeaPracticeQuestions = [
  Question(
    text: "What is the Main Idea in a paragraph?",
    options: [
      "A specific example supporting the text.",
      "The most important point the writer wants to communicate.",
      "A minor detail mentioned in the passage.",
      "The longest sentence in the paragraph.",
    ],
    correctIndex: 1,
  ),

  Question(
    text: "What is the correct difference between Topic and Main Idea?",
    options: [
      "Topic is a full sentence; Main Idea is just a word.",
      "Topic tells what the paragraph is about; Main Idea tells what the writer says about that topic.",
      "Topic contains examples; Main Idea contains numbers and facts.",
      "Topic and Main Idea mean exactly the same thing.",
    ],
    correctIndex: 1,
  ),

  Question(
    text: "Which option is an example of a Topic?",
    options: [
      "Dogs are loyal pets.",
      "Dogs help protect houses.",
      "The reasons why dogs are useful.",
      "Dogs.",
    ],
    correctIndex: 3,
  ),

  Question(
    text:
        "`Dogs are popular pets because they are friendly, loyal, and helpful to humans. Many families around the world choose dogs as companions because they can protect homes, play with children, and follow commands.` \n\nWhat is the Main Idea of the paragraph about dogs?",
    options: [
      "Dogs can follow many commands.",
      "Dogs are popular pets because they are friendly, loyal, and helpful to humans.",
      "Many families own dogs as pets.",
      "Dogs bark when strangers come.",
    ],
    correctIndex: 1,
  ),

  Question(
    text: "What is the purpose of supporting details in a paragraph?",
    options: [
      "To introduce a completely new topic.",
      "To explain, support, or prove the Main Idea.",
      "To make the paragraph look longer.",
      "To distract the reader from the topic.",
    ],
    correctIndex: 1,
  ),

  Question(
    text:
        "`Regular exercise plays an important role in keeping the body healthy. "
        "It helps improve heart function, strengthens muscles, and boosts energy levels. "
        "People who exercise regularly often feel more active and less stressed.`\n\n"
        "Which sentence is a Supporting Detail of the idea 'Exercise improves health'?",
    options: [
      "Exercise is important for everyone.",
      "Exercise helps keep the heart strong.",
      "People should exercise more often.",
      "Health is a basic need for humans.",
    ],
    correctIndex: 1,
  ),

  Question(
    text: "How do you find the Main Idea of a paragraph?",
    options: [
      "Read only the first sentence.",
      "Ignore all details and examples.",
      "Read the whole paragraph and identify the central message.",
      "Look only at numbers and data.",
    ],
    correctIndex: 2,
  ),

  Question(
    text:
        "`Water is essential for the body because it helps with digestion, keeps the body hydrated, "
        "and supports overall health. While many people like to drink sugary beverages such as soda "
        "or sweet tea, these drinks often contain too much sugar and can be unhealthy if consumed too often. "
        "That’s why choosing water is usually a better and healthier option.`\n\n"
        "What is the Main Idea of the paragraph about water?",
    options: [
      "Sugary drinks taste good.",
      "Water helps the body function but sugary drinks contain too much sugar.",
      "People buy many different drinks each day.",
      "Water is a healthier choice than sugary drinks.",
    ],
    correctIndex: 3,
  ),

  Question(
    text:
        "`Social media has become an important part of modern life. "
        "People use it to communicate with friends and family, share information instantly, "
        "and stay updated on events happening around the world. Because of these benefits, "
        "social media plays a significant role in helping people stay connected.`\n\n"
        "According to the paragraph, social media is important because...",
    options: [
      "Everyone uses social media every day.",
      "It helps people communicate, share information, and stay connected.",
      "It is only used for entertainment and fun.",
      "It completely replaces face-to-face interactions.",
    ],
    correctIndex: 1,
  ),

  Question(
    text:
        "Based on the strategies explained in the video about finding the main idea, which strategy is NOT mentioned in the video?",
    options: [
      "Using titles and headings",
      "Using topic sentences",
      "Using concluding sentences",
      "Find the most difficult word",
    ],
    correctIndex: 3,
  ),
];
